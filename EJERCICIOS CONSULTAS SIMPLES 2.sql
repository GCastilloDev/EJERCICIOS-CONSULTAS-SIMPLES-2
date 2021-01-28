/*1. List the customers without payments in 2003.*/
SELECT * FROM customers WHERE NOT EXISTS(SELECT 1 FROM payments WHERE payments.customerNumber = customers.customerNumber AND YEAR(paymentDate) = 2003);

/*2. List the amount paid by each customer.*/
SELECT (SELECT customerName FROM customers WHERE payments.customerNumber = customerNumber) AS cliente,
SUM(amount) AS Total FROM payments GROUP BY customerNumber;

/*3. List the products that have not been sold.*/
SELECT productName, productCode FROM products WHERE NOT EXISTS(SELECT 1 FROM orderdetails WHERE orderdetails.productCode = products.productCode);

-- S18_3233
-- SELECT * FROM orderdetails WHERE productCode = 'S18_3233';

/*4. Report the number of orders 'On Hold' for each customer*/
SELECT (SELECT customerName FROM customers
WHERE customers.customerNumber = pedidos.customerNumber) AS cliente,COUNT(customerNumber) AS 'Pedidos On Hold' FROM orders AS pedidos
WHERE pedidos.`status` = 'On Hold' GROUP BY customerNumber;

/*5. List orders containing more than two products*/
SELECT *, COUNT(orderNumber) AS 'productos' FROM orderdetails GROUP BY orderNumber HAVING COUNT(orderNumber) > 2;

/*6. List products sold by order date*/
SELECT (SELECT orderDate FROM orders WHERE orders.orderNumber = orderdetails.orderNumber) AS 'Fecha pedido', 
(SELECT productName FROM products WHERE products.productCode = orderdetails.productCode) AS 'Producto' FROM orderdetails;

/*7. List the names of customers and their corresponding order number where a particular order from that customer has a value greater than $25,000?*/
SELECT orderNumber,
(SELECT customerName FROM customers WHERE customers.customerNumber = orders.customerNumber) AS cliente,
(SELECT SUM(quantityOrdered * priceEach) AS 'TOTAL' FROM orderdetails WHERE orderdetails.orderNumber = orders.orderNumber GROUP BY orderNumber) AS total
FROM orders HAVING total > 25000 ORDER BY total;

/*8. Are there any products that appear on all orders?*/
-- SELECT COUNT(*) AS 'x' FROM orderdetails AS productos GROUP BY orderNumber;

/*9. List the products ordered on 2003.*/
SELECT
(SELECT YEAR(orderDate) FROM orders WHERE orders.orderNumber = orderdetails.orderNumber) AS año,
(SELECT productName FROM products WHERE products.productCode = orderdetails.productCode) AS producto
FROM orderdetails
GROUP BY producto
HAVING año = 2003;

/*10. What is the quantity on hand for products listed on 'On Hold' orders?*/
SELECT orderNumber, quantityOrdered,
(SELECT quantityInStock FROM products WHERE products.productCode = orderdetails.productCode) AS stock,
(SELECT productName FROM products WHERE products.productCode = orderdetails.productCode) AS producto
FROM orderdetails
HAVING (SELECT status FROM orders WHERE orders.orderNumber = orderdetails.orderNumber) = 'On Hold';