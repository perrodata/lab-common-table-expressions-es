# 1. Escribe una CTE que liste los nombres y cantidades de los productos con un precio unitario mayor a $50.

WITH ExpensiveProducts AS (
    SELECT 
        p.ProductName, 
        p.Unit
    FROM 
        products p
    WHERE 
        p.Price > 50
)
SELECT 
    *
FROM 
    ExpensiveProducts;

#2. ¿Cuáles son los 5 productos más rentables?

WITH ProductRevenueCTE AS (
    SELECT
        p.ProductID,          
        p.ProductName,       
        SUM(od.Quantity * p.Price) AS TotalRevenue 
    FROM
        Products p            
    INNER JOIN
        OrderDetails od       
    ON
        p.ProductID = od.ProductID 
    GROUP BY
        p.ProductID,          
        p.ProductName         
)

SELECT
	ProductID,
    ProductName,              
    TotalRevenue              
FROM
    ProductRevenueCTE
ORDER BY
    TotalRevenue DESC
LIMIT 5;

# 3. Escribe una CTE que liste las 5 categorías principales según el número de productos que tienen.
WITH CategoryProductCountCTE AS (
    SELECT
        c.CategoryID,
        c.CategoryName,
        COUNT(p.ProductID) AS ProductCount
    FROM
        Categories c
    LEFT JOIN
        Products p
    ON
        c.CategoryID = p.CategoryID
    GROUP BY
        c.CategoryID,
        c.CategoryName
)

SELECT
    CategoryName,
    ProductCount
FROM
    CategoryProductCountCTE
ORDER BY
    ProductCount DESC
LIMIT 5;

# 4. Escribe una CTE que muestre la cantidad promedio de pedidos para cada categoría de producto.

WITH CategoryOrderCountCTE AS (
    SELECT
        c.CategoryID,
        c.CategoryName,
        COUNT(DISTINCT od.OrderID) AS OrderCount
    FROM
        Categories c
    LEFT JOIN
        Products p ON c.CategoryID = p.CategoryID
    LEFT JOIN
        OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY
        c.CategoryID,
        c.CategoryName
)

SELECT
    c.CategoryName,
    AVG(co.OrderCount) AS AverageOrderCount
FROM
    Categories c
LEFT JOIN
    (
        SELECT
            p.CategoryID,
            COUNT(DISTINCT od.OrderID) AS OrderCount
        FROM
            Products p
        INNER JOIN
            OrderDetails od ON p.ProductID = od.ProductID
        GROUP BY
            p.CategoryID
    ) co ON c.CategoryID = co.CategoryID
GROUP BY
    c.CategoryName;
    
# 5. Crea una CTE para calcular el importe medio de los pedidos para cada cliente.
WITH OrderAmounts AS (
    SELECT
        o.CustomerID,
        SUM(od.Quantity * p.Price) AS TotalOrderAmount
    FROM
        Orders o
    INNER JOIN
        OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN
        Products p ON od.ProductID = p.ProductID
    GROUP BY
        o.CustomerID, o.OrderID
), CustomerAverageOrderAmount AS (
    SELECT
        CustomerID,
        AVG(TotalOrderAmount) AS AverageOrderAmount
    FROM
        OrderAmounts
    GROUP BY
        CustomerID
)

SELECT
    c.CustomerID,
    c.CustomerName,
    COALESCE(AverageOrderAmount, 0) AS AverageOrderAmount
FROM
    Customers c
LEFT JOIN
    CustomerAverageOrderAmount caoa ON c.CustomerID = caoa.CustomerID;

# 6. Crea una CTE para calcular el importe medio de los pedidos para cada cliente.
WITH ProductSales AS (
    SELECT
        p.ProductName,
        SUM(od.Quantity * p.Price) AS TotalSales
    FROM
        OrderDetails od
    INNER JOIN
        Products p ON od.ProductID = p.ProductID
    GROUP BY
        p.ProductName
)

SELECT
    ProductName,
    TotalSales
FROM
    ProductSales
ORDER BY
    TotalSales DESC;