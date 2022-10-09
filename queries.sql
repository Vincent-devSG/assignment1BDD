-- ------------------------------------------------------
-- NOTE: DO NOT REMOVE OR ALTER ANY LINE FROM THIS SCRIPT
-- ------------------------------------------------------

select 'Query 00' as '';
-- Show execution context
select current_date(), current_time(), user(), database();
-- Conform to standard group by constructs
set session sql_mode = 'ONLY_FULL_GROUP_BY';

-- Write the SQL queries that return the information below:
-- Ecrire les requêtes SQL retournant les informations ci-dessous:

select 'Query 01' as '';
-- The countries of residence the supplier had to ship products to in 2014
-- Les pays de résidence où le fournisseur a dû envoyer des produits en 2014
SELECT DISTINCT P.origin
FROM products P

         JOIN orders O on P.pid = O.pid
WHERE o.odate BETWEEN '2014-1-1' AND '2014-12-31';

select 'Query 02' as '';
-- For each known country of origin, its name, the number of products from that country, their lowest price, their highest price
-- Pour chaque pays d'orgine connu, son nom, le nombre de produits de ce pays, leur plus bas prix, leur plus haut prix
SELECT P.origin,
       COUNT(*)     as nb_products,
       MIN(P.price) as min_price,
       MAX(P.price) as max_price
FROM products P
GROUP BY P.origin
ORDER BY COUNT(*) DESC;


select 'Query 03' as '';
-- The customers who ordered in 2014 all the products (at least) that the customers named 'Smith' ordered in 2013
-- Les clients ayant commandé en 2014 tous les produits (au moins) commandés par les clients nommés 'Smith' en 2013
SELECT C.cid,
       C.cname
FROM Customers C

         CROSS JOIN (SELECT DISTINCT P.pid
                     FROM Customers C
                              INNER JOIN Orders O ON C.cid = O.cid
                              INNER JOIN Products P ON O.pid = P.pid
                     WHERE C.cname = 'Smith'
                       AND YEAR(O.odate) = 2013) X

         LEFT JOIN (SELECT DISTINCT C.cid,
                                    P.pid
                    FROM Customers C
                             INNER JOIN Orders O ON C.cid = O.cid
                             INNER JOIN Products P ON O.pid = P.pid
                    WHERE YEAR(O.odate) = 2014) R ON C.cid = R.cid AND X.pid = R.pid AND C.cname <> 'Smith'
GROUP BY C.cid
HAVING COUNT(X.pid) = COUNT(R.pid);



select 'Query 04' as '';
-- For each customer and each product, the customer's name, the product's name, the total amount ordered by the customer for that product,
-- sorted by customer name (alphabetical order), then by total amount ordered (highest value first), then by product id (ascending order)
-- Par client et par produit, le nom du client, le nom du produit, le montant total de ce produit commandé par le client,
-- trié par nom de client (ordre alphabétique), puis par montant total commandé (plus grance valeur d'abord), puis par id de produit (croissant)
SELECT c.cname, p.pname,p.price*o.quantity as total_amount_ordered,p.pid
from products p join orders o on p.pid = o.pid join customers c on o.cid = c.cid
ORDER BY c.cname;

SELECT c.cname, p.pname,p.price*o.quantity as total_amount_ordered,p.pid
from products p join orders o on p.pid = o.pid join customers c on o.cid = c.cid
ORDER BY  total_amount_ordered DESC;

SELECT c.cname, p.pname,p.price*o.quantity as total_amount_ordered,p.pid
from products p join orders o on p.pid = o.pid join customers c on o.cid = c.cid
ORDER BY  p.pid ASC;

select 'Query 05' as '';
-- The customers who only ordered products originating from their country
-- Les clients n'ayant commandé que des produits provenant de leur pays
SELECT DISTINCT c1.*
FROM customers c1
         JOIN orders o ON c1.cid = o.cid
         JOIN products p ON c1.residence = p.origin AND p.pid = o.pid
    AND NOT EXISTS(
            SELECT DISTINCT c1.cid, o.cid
            FROM customers c
                     JOIN orders o ON c1.cid = o.cid
                     JOIN products p ON c1.residence <> p.origin AND p.pid = o.pid
        );


select 'Query 06' as '';
-- The customers who ordered only products originating from foreign countries
-- Les clients n'ayant commandé que des produits provenant de pays étrangers
SELECT DISTINCT c1.*
FROM customers c1
         JOIN orders o ON c1.cid = o.cid
         JOIN products p ON (c1.residence <> p.origin OR c1.residence IS NULL) AND p.pid = o.pid
    AND NOT EXISTS(
            SELECT DISTINCT c1.cid, o.cid
            FROM customers c
                     JOIN orders o ON c1.cid = o.cid
                     JOIN products p ON c1.residence = p.origin AND p.pid = o.pid
        );


select 'Query 07' as '';
-- The difference between 'USA' residents' per-order average quantity and 'France' residents' (USA - France)
-- La différence entre quantité moyenne par commande des clients résidant aux 'USA' et celle des clients résidant en 'France' (USA - France)
SELECT (SELECT AVG(O1.quantity) as USA_Quantity
        from orders O1
                 join customers c on O1.cid = c.cid
        where c.residence = 'USA')     as Average_Quantity_USA,
       (SELECT AVG(O2.quantity) as FRANCE_Quantity
        from orders O2
                 join customers c1 on O2.cid = c1.cid
        where c1.residence = 'FRANCE') as Average_Quantity_FRANCE;


select 'Query 08' as '';
-- The products ordered throughout 2014, i.e. ordered each month of that year
-- Les produits commandés tout au long de 2014, i.e. commandés chaque mois de cette année
SELECT DISTINCT P.pname as Produits_Commandés_tout_au_long_de_2014
from products P
         join orders o on P.pid = o.pid
where MONTH(o.odate) = 1
  AND MONTH(o.odate) = 2
  AND MONTH(o.odate) = 3
  AND MONTH(o.odate) = 4
  AND MONTH(o.odate) = 5
  AND MONTH(o.odate) = 6
  AND MONTH(o.odate) = 7
  AND MONTH(o.odate) = 8
  AND MONTH(o.odate) = 9
  AND MONTH(o.odate) = 10
  AND MONTH(o.odate) = 11
  AND MONTH(o.odate) = 12
  AND YEAR(o.odate) = 2014;

select 'Query 09' as '';
-- The customers who ordered all the products that cost less than $5
-- Les clients ayant commandé tous les produits de moins de $5
SELECT *
FROM customers
WHERE -1 NOT IN
      (SELECT COALESCE(pid_display, -1)
       FROM (SELECT DISTINCT pid AS pid_display FROM orders WHERE customers.cid = orders.cid) AS Table_A
                RIGHT JOIN (SELECT pid from products where price < 5) AS Table_B ON Table_A.pid_display = Table_B.pid);



select 'Query 10' as '';
-- The customers who ordered the greatest number of common products. Display 3 columns: cname1, cname2, number of common products, with cname1 < cname2
-- Les clients ayant commandé le grand nombre de produits commums. Afficher 3 colonnes : cname1, cname2, nombre de produits communs, avec cname1 < cname2


select 'Query 11' as '';
-- The customers who ordered the largest number of products
-- Les clients ayant commandé le plus grand nombre de produits
SELECT c.*, count(DISTINCT o.pid) AS product_number
FROM customers c
         JOIN orders o ON c.cid = o.cid
GROUP BY c.cid
ORDER BY count(DISTINCT o.pid) DESC
LIMIT 1;


select 'Query 12' as '';
-- The products ordered by all the customers living in 'France'
-- Les produits commandés par tous les clients vivant en 'France'
SELECT p.*
from products p
         join orders o on p.pid = o.pid
         join (select * from customers where customers.residence = 'FRANCE') as customers1 on customers1.cid = o.cid;

select 'Query 13' as '';
-- The customers who live in the same country customers named 'Smith' live in (customers 'Smith' not shown in the result)
-- Les clients résidant dans les mêmes pays que les clients nommés 'Smith' (en excluant les Smith de la liste affichée)
SELECT c.*
FROM customers c
WHERE c.residence = (SELECT residence FROM customers WHERE cname = 'Smith')
  AND c.cname <> 'Smith';


select 'Query 14' as '';
-- The customers who ordered the largest total amount in 2014
-- Les clients ayant commandé pour le plus grand montant total sur 2014
SELECT c.*
from customers c
         join
     (SELECT Cid_C, sum(tot1) as TOTAL_Spent
      from (select c.cid as Cid_C, o.cid as Cid_O, sum(p.price * o.quantity) as tot1
            from orders o
                     join customers c on o.cid = c.cid
                     join products p on o.pid = p.pid and YEAR(o.odate) = 2014
            group by o.cid, p.pid
            order by o.cid) AS X
      WHERE Cid_C = Cid_O
      group by Cid_O
      order by TOTAL_Spent DESC
      LIMIT 1) AS Z
     on cid = Z.Cid_C;


select 'Query 15' as '';
-- The products with the largest per-order average amount
-- Les produits dont le montant moyen par commande est le plus élevé
SELECT p.*, AVG(o.quantity*p.price) as avg_price_per_order
from products p  join orders o on p.pid = o.pid
GROUP BY p.pname ORDER BY avg_price_per_order DESC LIMIT 1;


select 'Query 16' as '';
-- The products ordered by the customers living in 'USA'
-- Les produits commandés par les clients résidant aux 'USA'
SELECT DISTINCT p.*
FROM products p
         JOIN orders o ON p.pid = o.pid
         JOIN customers c ON o.cid = c.cid
WHERE c.residence = (SELECT c.residence FROM customers c WHERE c.residence = 'USA');

select 'Query 17' as '';
-- The pairs of customers who ordered the same product en 2014, and that product. Display 3 columns: cname1, cname2, pname, with cname1 < cname2
-- Les paires de client ayant commandé le même produit en 2014, et ce produit. Afficher 3 colonnes : cname1, cname2, pname, avec cname1 < cname2


select 'Query 18' as '';
-- The products whose price is greater than all products from 'India'
-- Les produits plus chers que tous les produits d'origine 'India'
SELECT *
from products p
where p.price > (SELECT MAX(p1.price) from products p1 where p1.origin = 'INDIA');


select 'Query 19' as '';
-- The products ordered by the smallest number of customers (products never ordered are excluded)
-- Les produits commandés par le plus petit nombre de clients (les produits jamais commandés sont exclus)
SELECT p.*, count(o.cid) as Number_of_customers
from products p
         join orders o on p.pid = o.pid
GROUP BY p.pid
ORDER BY Number_of_customers
LIMIT 1;



select 'Query 20' as '';
-- For all countries listed in tables products or customers, including unknown countries: the name of the country, the number of customers living in this country, the number of products originating from that country
-- Pour chaque pays listé dans les tables products ou customers, y compris les pays inconnus : le nom du pays, le nombre de clients résidant dans ce pays, le nombre de produits provenant de ce pays


