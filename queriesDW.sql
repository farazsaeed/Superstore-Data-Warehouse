#1
#Present total sales of all products supplied by each supplier with respect to quarter and
#month

select a.supplier_id, a.supplier_name, a.product_id, a.product_name, a.quarter_sale, a.quarter_num
,b.monthly_sale, b.month_num
from
( select a.supplier_id, b.supplier_name, sum(a.total_sale) 'quarter_sale', 
c.qquarter 'quarter_num', a.product_id, d.product_name from fact_sale a join dim_supplier b join dim_date c join dim_product d 
on( a.supplier_id = b.supplier_id and a.t_date = c.t_date and a.product_id = d.product_id) 
group by a.supplier_id,a.product_id, c.qquarter order by a.supplier_id) a
join
( select a.supplier_id, b.supplier_name, sum(a.total_sale) 'monthly_sale', 
c.mmonth 'month_num', c.qquarter 'quarter_num', a.product_id, d.product_name from fact_sale a join dim_supplier b join dim_date c join dim_product d 
on( a.supplier_id = b.supplier_id and a.t_date = c.t_date and a.product_id = d.product_id) 
group by a.supplier_id,a.product_id, c.mmonth order by a.supplier_id) b
on(a.SUPPLIER_ID = b.supplier_id and a.PRODUCT_ID = b.product_id and
 a.quarter_num = b.quarter_num);



#2
#Present total sales of each product sold by each store. The output should be organised
#store wise and then product wise under each store.
select a.total_sale, a.store_id, b.store_name ,a.product_id, c.product_name 
from fact_sale a join dim_product c join dim_store b 
on(a.product_id = c.product_id and a.store_id = b.store_id)
group by a.store_id,a.product_id order by a.store_id asc;

#3
#Find the 5 most popular products sold over the weekends.

select a.product_id, c.product_name ,sum(a.quantity) 'Quantity', a.t_date 'Date' from fact_sale a join 
(select t_date from dim_date where wweekend = 1 ) b join dim_product c 
on(a.t_date = b.t_date and a.product_id = c.product_id)
group by a.product_id order by sum(a.quantity) desc limit 5;

#4
#Present the quarterly sales of each product for year 2016 using drill down query concept.
#Note: each quarter sale must be a column.


select a.product_id, a.product_name, a.First_Quarter,
b.Second_quarter, c.Third_quarter, d.Fourth_quarter
from 
(select a.product_id, b.product_name, sum(a.TOTAL_SALE) as 'First_Quarter'
from fact_sale a JOIN dim_product b JOIN dim_date c
on (a.t_date = c.T_DATE and a.product_id = b.product_id and c.qquarter = 1 and c.yyear = 2016)
group by a.product_id) a
JOIN
(select a.product_id, b.product_name, sum(a.TOTAL_SALE) as 'Second_quarter'
from fact_sale a JOIN dim_product b JOIN dim_date c
on (a.t_date = c.T_DATE and a.product_id = b.product_id and c.qquarter = 3 and c.yyear = 2016)
group by a.product_id) b
JOIN
(select a.product_id, b.product_name, sum(a.TOTAL_SALE) as 'Third_quarter'
from fact_sale a JOIN dim_product b JOIN dim_date c
on (a.t_date = c.T_DATE and a.product_id = b.product_id and c.qquarter = 3 and c.yyear = 2016)
group by a.product_id) c
JOIN
(select a.product_id, b.product_name, sum(a.TOTAL_SALE) as 'Fourth_quarter'
from fact_sale a JOIN dim_product b JOIN dim_date c
on (a.t_date = c.T_DATE and a.product_id = b.product_id and c.qquarter = 4 and c.yyear = 2016)
group by a.product_id) d
on (a.product_id = b.product_id and a.product_id = c.product_id and a.product_id = d.product_id)
group by a.product_id order by a.product_id ;

#5
#Extract total sales of each product for the first and second half of year 2016 along with its
#total yearly sales.

select a.product_id, a.product_name, a.first_half_sale, b.second_half_sale, 
(a.first_half_sale+b.second_half_sale) 'total yearly sale' from
(select sum(a.total_sale) as first_half_sale, a.product_id, b.product_name from 
fact_sale a join dim_product b join dim_date c on a.product_id = b.product_id 
and a.t_date = c.t_date where c.qquarter = 1 or c.qquarter = 2 and c.t_date = 2016
group by a.product_id) a 
join
(select sum(a.total_sale) as second_half_sale, a.product_id, b.product_name from 
fact_sale a join dim_product b join dim_date c on a.product_id = b.product_id 
and a.t_date = c.t_date where c.qquarter = 3 or c.qquarter = 4 and c.t_date = 2016
group by a.product_id) b
group by a.product_id order by a.product_id;
 

#6
#Create a materialised view with name “STOREANALYSIS_MV” that presents the product-
#wise sales analysis for each store.
drop table storeanalysis_mv;
create table storeanalysis_mv(
store_id varchar(20) not null,
product_id varchar(20) not null,
total_sale varchar(20)
);

SELECT store_id 'STORE_ID', product_id 'PROD_ID',
    SUM(total_sale) as 'STORE_TOTAL'
	FROM fact_sale GROUP BY store_id,product_id 
    ORDER BY store_id asc;

DROP PROCEDURE if exists StoreAnalysis;

DELIMITER %%
CREATE PROCEDURE StoreAnalysis ()
BEGIN
	TRUNCATE TABLE storeanalysis_mv;
	INSERT INTO storeanalysis_mv
    
	SELECT store_id 'STORE_ID', product_id 'PROD_ID',
    SUM(total_sale) as 'STORE_TOTAL'
	FROM fact_sale GROUP BY store_id,product_id 
    ORDER BY store_id asc;

END;
%%
DELIMITER ;

call StoreAnalysis();
select * from storeanalysis_mv;







