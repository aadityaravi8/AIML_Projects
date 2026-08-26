/*
SQL Project - Aaditya Kumar Ravi
-----------------------------------------------------------------------------------------------------------------------------------
													    Guidelines
-----------------------------------------------------------------------------------------------------------------------------------

The provided document is a guide for the project. Follow the instructions and take the necessary steps to finish
the project in the SQL file			

-----------------------------------------------------------------------------------------------------------------------------------
                                                         Queries
                                               
-----------------------------------------------------------------------------------------------------------------------------------*/
  
/*-- QUESTIONS RELATED TO CUSTOMERS
 [Q1] What is the distribution of customers across states?
 Hint: For each state, count the number of customers.*/

--Answer: 
	SELECT 
		STATE, COUNT(CUSTOMER_ID) AS CUSTOMER_COUNT
	FROM
		CUSTOMER_T
	GROUP BY STATE
	ORDER BY CUSTOMER_COUNT DESC;

/* 
** Comments, Observations and Insights:
-- Above query returns 2 columns STATE and CUSTOMER_COUNT which shows all the states present in CUSTOMER_T table and CUSTOMER_COUNT shows the count 
   of how many customers belong to each STATE 
-- We have used GROUP BY clause as we are using aggregate function called count() to get the count of customers in each state.
-- Also, we have ordered the result in descending order of CUSTOMER_COUNT, so that it will clearly show which state has highest and lowest customers count
-- Looking at the result of the query, we find that States California and Texas has highest number of customers i.e 97, followed by Florida (86 customers), 
   New York (69 customers) and so on. 
-- California and Texas has same number of customers count 97.
-- Maine, Wyoming, Vermont states have lowest number of customer count i.e 1 preceded by states North Dakota, Mississippi (2 customers), New Hampshire, 
   Montana(3 customers) and so on. 
*/
-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q2] What is the average rating in each quarter?
-- Very Bad is 1, Bad is 2, Okay is 3, Good is 4, Very Good is 5.

Hint: Use a common table expression and in that CTE, assign numbers to the different customer ratings. 
      Now average the feedback for each quarter. */

-- Answer: 
	WITH ORDER_T_QUARTERLY_RATING_CTE AS (
		SELECT 
			*,
			CASE
				WHEN CUSTOMER_FEEDBACK = 'Very Bad' THEN 1
				WHEN CUSTOMER_FEEDBACK = 'Bad' THEN 2
				WHEN CUSTOMER_FEEDBACK = 'Okay' THEN 3
				WHEN CUSTOMER_FEEDBACK = 'Good' THEN 4
				WHEN CUSTOMER_FEEDBACK = 'Very Good' THEN 5
			END AS CUSTOMER_RATING
		FROM
			ORDER_T
	)
	SELECT 
		QUARTER_NUMBER, 
		AVG(CUSTOMER_RATING) AS AVG_CUSTOMER_RATING
	FROM
		ORDER_T_QUARTERLY_RATING_CTE
	GROUP BY QUARTER_NUMBER
	ORDER BY AVG_CUSTOMER_RATING DESC;

/*
** Comments, Observations and Insights:
-- We created CTE called ORDER_T_QUARTERLY_RATING_CTE which contains all columns of ORDER_T table and one more column called CUSTOMER_RATING based on 
   CUSTOMER_FEEDBACK column. We used CASE statement and we assigned numbers for CUSTOMER_FEEDBACK as below, so that we can find out average:
   Very Bad is 1, Bad is 2, Okay is 3, Good is 4, Very Good is 5
-- Then we used select query and grouped it by QUARTER_NUMBER, so that we can find averge of CUSTOMER_RATING for each quarter.
-- We have ordered by AVG_CUSTOMER_RATING in descending order and looking at the results we find that CUSTOMER_RATING avg is dropping each quarter 
   going forward. 
-- Quarter 1 has avg customer rating 3.5548 which is highest.
-- Quarter 2 has avg customer rating 3.3550 which is lower than quarter 1.
-- Quarter 3 has avg customer rating as 2.9563 which is lower than quarter 1 and 2.
-- Quarter 4 has avg customer rating as 2.3970 which is lower than quarter 1, 2 and 3.
-- So we observe a decrease trend in customer ratings.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q3] Are customers getting more dissatisfied over time?

Hint: Need the percentage of different types of customer feedback in each quarter. Use a common table expression and
	  determine the number of customer feedback in each category as well as the total number of customer feedback in each quarter.
	  Now use that common table expression to find out the percentage of different types of customer feedback in each quarter.
      Eg: (total number of very good feedback/total customer feedback)* 100 gives you the percentage of very good feedback. */
	  
-- Answer:     
	WITH QUARTERLY_PER_FEEDBACK_COUNT_CTE AS (
		SELECT 
			QUARTER_NUMBER,
			CUSTOMER_FEEDBACK,
			COUNT(CUSTOMER_FEEDBACK) AS CNT_CUSTOMER_FEEDBACK
		FROM
			ORDER_T
		GROUP BY QUARTER_NUMBER , CUSTOMER_FEEDBACK
		ORDER BY QUARTER_NUMBER ASC
	),
	TOTAL_QUARTERLY_FEEDBACK_COUNT_CTE AS (
		SELECT 
			QUARTER_NUMBER,
			COUNT(QUARTER_NUMBER) AS TOTAL_QUARTERLY_FEEDBACK
		FROM
			ORDER_T
		GROUP BY QUARTER_NUMBER
		ORDER BY QUARTER_NUMBER
	)
	SELECT 
		QPFC.QUARTER_NUMBER,
		QPFC.CUSTOMER_FEEDBACK,
		QPFC.CNT_CUSTOMER_FEEDBACK,
		TQFC.TOTAL_QUARTERLY_FEEDBACK,
		(QPFC.CNT_CUSTOMER_FEEDBACK / TQFC.TOTAL_QUARTERLY_FEEDBACK) * 100 AS QUARTERLY_PER_FEEDBACK_PERCENTAGE
	FROM
		QUARTERLY_PER_FEEDBACK_COUNT_CTE QPFC
			LEFT JOIN
		TOTAL_QUARTERLY_FEEDBACK_COUNT_CTE TQFC ON TQFC.QUARTER_NUMBER = QPFC.QUARTER_NUMBER
	ORDER BY QPFC.QUARTER_NUMBER ASC, 
			 FIELD(QPFC.CUSTOMER_FEEDBACK, 'Very Bad', 'Bad', 'Okay', 'Good', 'Very Good');

/* 
** Comments, Observations and Insights:
-- We have Orderded the query result by this sequence per quarter: 'Very Bad', 'Bad', 'Okay', 'Good', 'Very Good' for readability.
-- To find if the customer are getting more dissatisfied over time, we can sum up QUARTERLY_PER_FEEDBACK_PERCENTAGE for Very Bad and Bad feedback 
   for each quarter.
-- Quarter 1 has Very Bad feedback percentage 10.9677 and Bad feedback percentage 11.2903 which sums up to 22.258
-- Quarter 2 has Very Bad feedback percentage 14.8855 and Bad feedback percentage 14.1221 which sums up to 29.007
-- Quarter 3 has Very Bad feedback percentage 17.9039 and Bad feedback percentage 22.7074 which sums up to 40.611
-- Quarter 4 has Very Bad feedback percentage 30.6533 and Bad feedback percentage 29.1457 which sums up to 59.799
-- We can see dissatisfied feedback percentage i.e (Very Bad and Bad) is increasing over time, quarter 1 had lowest dissatisfied percentage and quarter 2,3,4
   dissatisfied percentage is increasing continuously over time.
*/
-- ---------------------------------------------------------------------------------------------------------------------------------

/*[Q4] Which are the top 5 vehicle makers preferred by the customer.

Hint: For each vehicle make what is the count of the customers.*/

-- Answer:
	SELECT 
		P.VEHICLE_MAKER,
		COUNT(DISTINCT O.CUSTOMER_ID) AS CUSTOMER_COUNT
	FROM
		PRODUCT_T P
			LEFT JOIN
		ORDER_T O ON P.PRODUCT_ID = O.PRODUCT_ID
	GROUP BY P.VEHICLE_MAKER
	ORDER BY CUSTOMER_COUNT DESC
	LIMIT 5;

/* 
** Observations and Insights:
-- Vehicle maker Chevrolet has the highest number of customers (83 customers) followed by Ford (63 customers), Toyota (52 customers), Dodge and Pontiac (50 customers)
*/
-- ---------------------------------------------------------------------------------------------------------------------------------

/*[Q5] What is the most preferred vehicle make in each state?

Hint: Use the window function RANK() to rank based on the count of customers for each state and vehicle maker. 
After ranking, take the vehicle maker whose rank is 1.*/

-- Answer: 
	WITH STATEWISE_VEHICLEMAKER_RANK_CTE AS (
		SELECT 
			C.STATE, 
			P.VEHICLE_MAKER, 
			COUNT(DISTINCT C.CUSTOMER_ID) AS CUSTOMER_COUNT,
			RANK() OVER (PARTITION BY C.STATE ORDER BY COUNT(DISTINCT C.CUSTOMER_ID) DESC) AS VEHICLEMAKER_RANK 
		FROM 
			ORDER_T O
				INNER JOIN 
			PRODUCT_T P ON P.PRODUCT_ID = O.PRODUCT_ID
				INNER JOIN 
			CUSTOMER_T C ON C.CUSTOMER_ID = O.CUSTOMER_ID
		GROUP BY C.STATE, P.VEHICLE_MAKER
	)
	SELECT 
		*
	FROM
		STATEWISE_VEHICLEMAKER_RANK_CTE S
	WHERE
		VEHICLEMAKER_RANK = 1
	ORDER BY S.STATE , S.VEHICLE_MAKER ASC;
	
-- We can also show one state at a time and all the preferred vehicle makers at rank 1 comma separated as follows:
	WITH STATEWISE_VEHICLEMAKER_RANK_CTE AS (
		SELECT 
			C.STATE, 
			P.VEHICLE_MAKER, 
			COUNT(DISTINCT C.CUSTOMER_ID) AS CUSTOMER_COUNT,
			RANK() OVER (PARTITION BY C.STATE ORDER BY COUNT(DISTINCT C.CUSTOMER_ID) DESC) AS VEHICLEMAKER_RANK 
		FROM 
			ORDER_T O
				INNER JOIN 
			PRODUCT_T P ON P.PRODUCT_ID = O.PRODUCT_ID
				INNER JOIN 
			CUSTOMER_T C ON C.CUSTOMER_ID = O.CUSTOMER_ID
		GROUP BY C.STATE, P.VEHICLE_MAKER
	)
	SELECT 
		STATE, 
		GROUP_CONCAT(VEHICLE_MAKER ORDER BY VEHICLE_MAKER SEPARATOR ', ') AS VEHICLE_MAKERS
	FROM
		STATEWISE_VEHICLEMAKER_RANK_CTE S
	WHERE
		VEHICLEMAKER_RANK = 1
	GROUP BY STATE
	ORDER BY S.STATE;
/*  
** Comments, Observations and Insights:
-- We have used CTE to rank the vehicle makers in each state based on distinct customer count
-- Also showing customer_count for vehicle maker in each state for better visibility
-- There are many states in which multiple vehicle maker has same customer count, so they are all marked as rank 1
-- State Texas has Chevrolet preferred vehicle with customer count 9 which is highest among other states.
-- State Florida has Toyota preferred vehicle with customer count 7 which is 2nd highest among the list.
-- State California has Audi, Chevrolet, Dodge, Ford, Nissan all preferred vehicle with customer count 6 for each, so they are all maked as rank 1 for the state.
-- State wise preferred vehicle is listed based on customer count as the result of query. 
-- Alternate way shows the result of query a better way. one state and all the vehicle makers at rank 1 in that state.
*/
-- ---------------------------------------------------------------------------------------------------------------------------------

/*QUESTIONS RELATED TO REVENUE and ORDERS 

-- [Q6] What is the trend of number of orders by quarters?

Hint: Count the number of orders for each quarter.*/

-- Answer:
	SELECT 
		QUARTER_NUMBER, 
		COUNT(ORDER_ID) AS ORDER_COUNT
	FROM
		ORDER_T
	GROUP BY QUARTER_NUMBER
	ORDER BY QUARTER_NUMBER;

/*  
** Comments, Observations and Insights:
-- We see a decreasing trend of orders by quarters. 
-- Quarter 1 has 310 orders, quarter 2 has 262 orders, quarter 3 has 229 orders, quarter 4 has just 199 orders.
-- Orders are decreasing quarter by quarter.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q7] What is the quarter over quarter % change in revenue? 

Hint: Quarter over Quarter percentage change in revenue means what is the change in revenue from the subsequent quarter to the previous quarter in percentage.
      To calculate you need to use the common table expression to find out the sum of revenue for each quarter.
      Then use that CTE along with the LAG function to calculate the QoQ percentage change in revenue.
*/

-- Answer:      
	WITH QUARTERLY_REVENUE_CTE AS (
		SELECT 
			QUARTER_NUMBER,
			SUM(VEHICLE_PRICE - (VEHICLE_PRICE * DISCOUNT)) AS REVENUE
		FROM
			ORDER_T
		GROUP BY QUARTER_NUMBER
		ORDER BY QUARTER_NUMBER
	)
	SELECT 
		QUARTER_NUMBER, 
		REVENUE, 
		LAG(REVENUE) OVER (ORDER BY QUARTER_NUMBER) AS PREVIOUS_REVENUE,
		(REVENUE-(LAG(REVENUE) OVER (ORDER BY QUARTER_NUMBER))) AS QoQ_REVENUE_CHANGE, 
		ROUND((REVENUE-(LAG(REVENUE) OVER (ORDER BY QUARTER_NUMBER)))/REVENUE*100,2) AS QoQ_REVENUE_CHANGE_PERCENTAGE
	FROM 
		QUARTERLY_REVENUE_CTE;      

/*
** Comments, Observations and Insights:
-- We are using SUM(Vehicle_Price - DiscountAmount) to calculate REVENUE, where DiscountAmount is being calculated as Vehicle_Price*Discount as Discount is already in percentage, we are not dividing it by 100, just multiplying discount to vehicle_price to find DiscountAmount.
-- QoQ_REVENUE_CHANGE is the revenue change amount by quarter over quarter 
-- QoQ_REVENUE_CHANGE_PERCENTAGE is the revenue change in percentage by quarter over quarter.
-- We see a revenue decrease trend quarter over quarter. 
-- 2nd quarter has 40.97% decrease in revenue compared to revenue of quarter 1.
-- 3rd quarter has 44.11% decrease in revenue compared to revenue of quarter 2.
-- 4th quarter has 7.98% decrease in revenue compared to revenue of quarter 3.
*/
-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q8] What is the trend of revenue and orders by quarters?

Hint: Find out the sum of revenue and count the number of orders for each quarter.*/

-- Answer: 
	SELECT 
		QUARTER_NUMBER,
		SUM(VEHICLE_PRICE - (VEHICLE_PRICE * DISCOUNT)) AS REVENUE,
		COUNT(ORDER_ID) AS ORDER_COUNT
	FROM
		ORDER_T
	GROUP BY QUARTER_NUMBER
	ORDER BY QUARTER_NUMBER;
	
/*  Comments, Observations and Insights:
--  Considering discount already in percentage divided by 100, we are not dividing it again by 100, just multiplying vehicle_price*discount to get 
    discount amount
--  We see decrease trend of revenue and order by quarter.
--  Quarter 1 has highest revenue 12100846.3799 and highest order count 310
--  Quarter 2 has comparitively less revenue and order count compared to quarter 1. Revenue 8584166.7654 and order count 262  
--  Quarter 3 has lesser revenue and order count compared to quarter 1 and 2. Revenue 5956470.3960 and order count 229 
--  Quarter 4 has lowest order count and hence lowest revenue. Revenue 5516516.1418	and order count 199
*/
-- ---------------------------------------------------------------------------------------------------------------------------------

/* QUESTIONS RELATED TO SHIPPING 
    [Q9] What is the average discount offered for different types of credit cards?

Hint: Find out the average of discount for each credit card type.*/

-- Answer: 
	SELECT 
		C.CREDIT_CARD_TYPE, AVG(O.DISCOUNT) AS AVG_DISCOUNT
	FROM
		CUSTOMER_T C
			INNER JOIN
		ORDER_T O ON O.CUSTOMER_ID = C.CUSTOMER_ID
	GROUP BY C.CREDIT_CARD_TYPE
	ORDER BY AVG_DISCOUNT DESC;

/*  Comments, Observations and Insights:
--  We have ordered the query result in descending order of avg discount just for readability that which credit card type has highest discount. 
--  We observe that CREDIT_CARD_TYPE laser has highest avg discount 0.643846 followed by mastercard 0.629500, maestro 0.624219 and so on.
--  diners-club-international card type has lowest avg discount 0.584000
--  Discounts on card ranging from 0.584000 to 0.643846.
*/
-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q10] What is the average time taken to ship the placed orders for each quarters?
	Hint: Use the dateiff function to find the difference between the ship date and the order date.
*/

-- Answer: 
	SELECT 
		QUARTER_NUMBER,
		AVG(DATEDIFF(SHIP_DATE, ORDER_DATE)) AS AVG_TIME_TAKEN_TO_SHIP
	FROM
		ORDER_T
	GROUP BY QUARTER_NUMBER
	ORDER BY QUARTER_NUMBER ASC;

/*  Comments, Observations and Insights:
--  We observe from query result that average time taken to ship the ordered item is increasing quarter by quarter. 
--  Average time taken to ship the ordered item in quarter 1 is 56 days. 
--  Average time taken to ship the ordered item in quarter 2 is 71 days. 
--  Average time taken to ship the ordered item in quarter 3 is 117 days. 
--  Average time taken to ship the ordered item in quarter 4 is 174 days. 
--  Worst shipping time may be one of the reasons in decreased order count and revenue quarter by quarter. 
*/
-- --------------------------------------------------------Done----------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------



