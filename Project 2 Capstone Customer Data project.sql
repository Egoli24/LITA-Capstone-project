CREATE TABLE customer_subscriptions (
    CustomerID INT,
    CustomerName VARCHAR(255),
    Region VARCHAR(50),
    SubscriptionType VARCHAR(50),
    SubscriptionStart DATE,
    SubscriptionEnd DATE,
    Canceled BOOLEAN,
    Revenue DECIMAL(10, 2)
);

--1: Total Number of Customers per Region --
SELECT "Region", COUNT("CustomerID") AS total_customers
FROM CustomerData
GROUP BY "Region";

--2: Most Popular Subscription Type --
SELECT "SubscriptionType", COUNT("CustomerID") AS total_subscribers
FROM CustomerData
GROUP BY "SubscriptionType"
ORDER BY total_subscribers DESC
LIMIT 1;

--3: Customers Who Canceled within 6 Months --
SELECT "CustomerID", "CustomerName", "SubscriptionType", "Region"
FROM CustomerData
WHERE "Canceled" = TRUE 
  AND ("SubscriptionEnd" - "SubscriptionStart") <= INTERVAL '6 months';

--4: Average Subscription Duration --
SELECT AVG("SubscriptionEnd" - "SubscriptionStart") AS avg_subscription_duration
FROM CustomerData;

--5: Customers with Subscriptions Longer than 12 Months --
SELECT "CustomerID", "CustomerName", "SubscriptionType", "Region"
FROM CustomerData
WHERE ("SubscriptionEnd" - "SubscriptionStart") > INTERVAL '12 months';

--6: Total Revenue by Subscription Type --
SELECT "SubscriptionType", SUM("Revenue") AS total_revenue
FROM CustomerData
GROUP BY "SubscriptionType";

--7: Top 3 Regions by Subscription Cancellation --
SELECT "Region", COUNT("CustomerID") AS cancellations
FROM CustomerData
WHERE "Canceled" = TRUE
GROUP BY "Region"
ORDER BY cancellations DESC
LIMIT 3;

--8: Total Number of Active and Canceled Subscriptions --
SELECT 
    COUNT(CASE WHEN "Canceled" = FALSE THEN 1 END) AS active_subscriptions,
    COUNT(CASE WHEN "Canceled" = TRUE THEN 1 END) AS canceled_subscriptions
FROM CustomerData;
