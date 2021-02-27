-- Assignment 3 Physical database design
-- Created by Sharjeel Sohail c3316130
-- Due date: November 31st 2019


-- % DROP ALL THE TABLES %

DROP TABLE IngredientOrder;
DROP TABLE Suppliers;
DROP TABLE IngredientsOnly;
DROP TABLE IngredientsLevel;
DROP TABLE Orders;
DROP TABLE WalkInOrder;
DROP TABLE PhoneOrder;
DROP TABLE Delivery;
DROP TABLE Pickup;
DROP TABLE EmployeePayDetails;
DROP TABLE EmployeeBankDetails;
DROP TABLE DriverPay;
DROP TABLE InStorePay;
DROP TABLE EmployeeInfo;
DROP TABLE EmployeeInfoBank;
DROP TABLE InStoreEmployee;
DROP TABLE DriverEmployee;
DROP TABLE Shifts;
DROP TABLE InStoreShift;
DROP TABLE DriverShift;
DROP TABLE MenuItems;
DROP TABLE Customers;


-- % CREATING ALL THE TABLES %

--SELECT * FROM IngredientOrder;
CREATE TABLE IngredientOrder(
	orderNo CHAR(10) PRIMARY KEY,
	orderDate DATETIME2, 
	totalAmount FLOAT NOT NULL,
	orderStatus VARCHAR(20) DEFAULT 'Pending',
	orderDescription CHAR(50),
	supplierCode CHAR(10),
	arrivalDate DATETIME2,
	-- Foreign key added later
);

--SELECT * FROM Suppliers;
CREATE TABLE Suppliers(
	supplierCode CHAR(10) PRIMARY KEY,
	supplierName CHAR(20) NOT NULL,
	supplierAddress VARCHAR(30),
	phoneNumber VARCHAR(10),
	emailAddress VARCHAR(30) UNIQUE,
	contactPerson CHAR(20) NOT NULL
);

--SELECT * FROM IngredientsOnly;
CREATE TABLE IngredientsOnly(
	IngCode CHAR(10),
	IngName CHAR(20) NOT NULL,
	IngType VARCHAR(10),
	IngDescription CHAR(30),
	CurrentStockLevel FLOAT,
	SuggestedCurrentLevel FLOAT NOT NULL,
	PRIMARY KEY (CurrentStockLevel)
);

--SELECT * FROM IngredientsLevel;
CREATE TABLE IngredientsLevel(
	CurrentStockLevel FLOAT PRIMARY KEY,
	LastStockLevel FLOAT,
	ReOrderLevel FLOAT
	FOREIGN KEY(CurrentStockLevel) REFERENCES IngredientsOnly(CurrentStockLevel) ON UPDATE CASCADE ON DELETE CASCADE
);

--SELECT * FROM Orders;
CREATE TABLE Orders(
	OrderId CHAR(10) PRIMARY KEY,
	customerId CHAR (10),
	PhoneNumber VARCHAR(10) UNIQUE,
	OrderAddress VARCHAR(30) NOT NULL,
	OrderType VARCHAR(10),
	dateAndTime DATETIME2,
	InAndOutTime DATETIME2,
	TotalItemsAndAmount VARCHAR(30) NOT NULL,
	PaymentMethod VARCHAR(20) DEFAULT 'Bank card',
	OrderStatus VARCHAR(20),
	OrderDescription CHAR(40),
	PickupOrDeliveryTime DATETIME2,
);

--SELECT * FROM WalkInOrder;
CREATE TABLE WalkInOrder(
	OrderId CHAR(10) PRIMARY KEY,
	WalkInTime DATETIME2,
	FOREIGN KEY (OrderId) REFERENCES Orders (OrderId) ON UPDATE CASCADE ON DELETE CASCADE
);

--SELECT * FROM PhoneOrder;
CREATE TABLE PhoneOrder(
	OrderId CHAR(10) PRIMARY KEY,
	TimeCallAnswered DATETIME2,
	TimeCallTerminated DATETIME2,
	FOREIGN KEY (OrderId) REFERENCES Orders (OrderId) ON UPDATE CASCADE ON DELETE CASCADE
);

--SELECT * FROM Delivery;
CREATE TABLE Delivery(
	OrderId CHAR(10) PRIMARY KEY,
	DeliveryAddress VARCHAR(40) NOT NULL,
	DeliveryTime DATETIME2,
	FOREIGN KEY (OrderId) REFERENCES PhoneOrder (OrderId) ON UPDATE CASCADE ON DELETE CASCADE
);

--SELECT * FROM Pickup;
CREATE TABLE Pickup(
	OrderId CHAR(10) PRIMARY KEY,
	PickupTime DATETIME2,
	FOREIGN KEY (OrderId) REFERENCES PhoneOrder (OrderId) ON UPDATE CASCADE ON DELETE CASCADE
);

--SELECT * FROM EmployeePayDetails;
CREATE TABLE EmployeePayDetails(
	PayRecordId VARCHAR(20) PRIMARY KEY,
	GrossPayment FLOAT,
	TaxWithheld FLOAT,
	TotalAmountPaid FLOAT NOT NULL,
	AccountNumber VARCHAR(20) UNIQUE,
	PayPeriodStartDate DATETIME2,
	PayPeriodEndDate DATETIME2,
);

--SELECT * FROM EmployeeBankDetails;
CREATE TABLE EmployeeBankDetails(
	AccountNumber VARCHAR(20) PRIMARY KEY,
	BankCode VARCHAR(10) NOT NULL,
	BankName CHAR(20),
	FOREIGN KEY(AccountNumber) REFERENCES EmployeePayDetails(PayRecordId) ON UPDATE CASCADE ON DELETE CASCADE
);

--SELECT * FROM DriverPay;
CREATE TABLE DriverPay(
	PayRecordId VARCHAR(20) PRIMARY KEY,
	PaidDeliveryRate FLOAT DEFAULT 'Undecided',
	DeliveriesPaid INT,
	FOREIGN KEY (PayRecordId) REFERENCES EmployeePayDetails (PayRecordId) ON UPDATE CASCADE ON DELETE CASCADE
);

--SELECT * FROM InStorePay;
CREATE TABLE InStorePay(
	PayRecordId VARCHAR(20) PRIMARY KEY,
	PaidHourlyRate FLOAT,
	HoursPaid FLOAT
	FOREIGN KEY (PayRecordId) REFERENCES EmployeePayDetails (PayRecordId) ON UPDATE CASCADE ON DELETE CASCADE
);

--SELECT * FROM EmployeeInfo;
CREATE TABLE EmployeeInfo(
	EmployeeNo VARCHAR(20) PRIMARY KEY,
	EmployeeStatus CHAR(10),
	FirstName CHAR(15) NOT NULL,
	LastName CHAR(15) NOT NULL,
	PostalAddress VARCHAR(30),
	ContactNo VARCHAR(10),
	TaxFileNumber VARCHAR(15),
	AccountNumber VARCHAR(20) UNIQUE,
	PaymentRate FLOAT DEFAULT 'Undecided',
	EmployeeDescription CHAR(30)
);

--SELECT * FROM EmployeeInfoBank;
CREATE TABLE EmployeeInfoBank(
	AccountNumber VARCHAR(20) PRIMARY KEY,
	BankCode VARCHAR(10) NOT NULL,
	BankName CHAR(20),
	FOREIGN KEY(AccountNumber) REFERENCES EmployeeInfo(EmployeeNo) ON UPDATE CASCADE ON DELETE CASCADE
);

--SELECT * FROM InStoreEmployee;
CREATE TABLE InStoreEmployee(
	EmployeeNo VARCHAR(20) PRIMARY KEY,
	HourlyRate FLOAT,
	FOREIGN KEY(EmployeeNo) REFERENCES EmployeeInfo(EmployeeNo) ON UPDATE CASCADE ON DELETE CASCADE
);

--SELECT * FROM DriverEmployee;
CREATE TABLE DriverEmployee(
	EmployeeNo VARCHAR(20) PRIMARY KEY,
	LicenseNo VARCHAR(10) NOT NULL,
	RatePerDelivery FLOAT,
	FOREIGN KEY(EmployeeNo) REFERENCES EmployeeInfo(EmployeeNo) ON UPDATE CASCADE ON DELETE CASCADE
);

--SELECT * FROM Shifts;
CREATE TABLE Shifts(
	ShiftID CHAR(10) PRIMARY KEY,
	StartDate DATETIME2,
	StartTime DATETIME2,
	EndDate DATETIME2,
	EndTime DATETIME2,
	ShiftType VARCHAR(10)
);

--SELECT * FROM InStoreShift;
CREATE TABLE InStoreShift(
	ShiftId CHAR(10) PRIMARY KEY,
	PayRecordId VARCHAR(20),
	EmployeeNo VARCHAR(20),
	NoOfHours FLOAT,
	FOREIGN KEY (ShiftId) REFERENCES Shifts (ShiftId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (PayRecordId) REFERENCES InStorePay(PayRecordId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (EmployeeNo) REFERENCES InStoreEmployee (EmployeeNo) ON UPDATE CASCADE ON DELETE CASCADE 
);

--SELECT * FROM DriverShift;
CREATE TABLE DriverShift(
	ShiftId CHAR(10) PRIMARY KEY,
	PayRecordId VARCHAR(20),
	EmployeeNo VARCHAR(20),
	NoOfDeliveries INT,
	FOREIGN KEY (ShiftId) REFERENCES Shifts (ShiftId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (PayRecordId) REFERENCES DriverPay (PayRecordId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (EmployeeNo) REFERENCES DriverEmployee (EmployeeNo) ON UPDATE CASCADE ON DELETE CASCADE 
);

--SELECT * FROM MenuItems;
CREATE TABLE MenuItems(
	ItemCode CHAR(10) PRIMARY KEY,
	ItemName CHAR(20) NOT NULL,
	Size VARCHAR(10),
	CurrentSellingPrice FLOAT,
	ItemDescription CHAR(50),
);

--SELECT * FROM Customers;
CREATE TABLE Customers(
	CustomerId CHAR(10) PRIMARY KEY,
	fName CHAR(15) NOT NULL,
	lName CHAR(15) NOT NULL,
	CustAdress VARCHAR(30),
	phoneNumber INT UNIQUE,
	CustStatus CHAR(15),
	CustOrder VARCHAR(50)
);

-- % ADDING FOREIGN KEYS INTO THE TABLE %

ALTER TABLE IngredientOrder
ADD FOREIGN KEY(supplierCode) REFERENCES Suppliers (supplierCode) ON UPDATE CASCADE ON DELETE CASCADE;

-- % INSERING SAMPLE DATA INTO THE TABLES %

INSERT INTO Suppliers
VALUES ('SUPP22', 'Travis', '109 University Drive NSW 2299', '0232447845', 'travisscott@gmail.com', 'Travis Scott');
INSERT INTO Suppliers
VALUES ('SUPP23', 'Kylie', '25 Nothcut Lane NSW 2675', '0444786908', 'kyliejenner@gmail.com', 'Mr Scott');
INSERT INTO Suppliers
VALUES ('SUPP24', 'Stormi', 'Evatt House UON NSW 2390', '0212767554', 'stormiscott1@gmail.com', 'Kylie Jenner');

INSERT INTO IngredientOrder
VALUES ('IO22334400', '2019-10-27  10:0:0', 1021.50, 'Confirmed', 'Please add plastic bags too', 'SUPP22', '2019-10-29  11:0:0');
INSERT INTO IngredientOrder
VALUES ('IO22334411', '2019-10-28  10:0:0', 499.98, 'Pending', 'Order should be here in two days', 'SUPP23', '2019-10-30  11:0:0');
INSERT INTO IngredientOrder
VALUES ('IO22334422', '2019-10-29  10:0:0', 202.43, 'On the way', 'Add extra spices if easy', 'SUPP24', '2019-10-31  11:0:0');

INSERT INTO IngredientsOnly
VALUES ('ING00123', 'Bega Cheese', 'Dairy', 'Fresh Cheese Slices', 89.4,175.00);
INSERT INTO IngredientsOnly
VALUES ('ING00124', 'Capsicum', 'Vegetable', 'Red Capsicum with leaf', 88.5,50.00);
INSERT INTO IngredientsOnly
VALUES ('ING00125', 'Red beans', 'Beans', 'Red protein beans', 10.0, 70.00);

INSERT INTO IngredientsLevel
VALUES (89.4, 44.40, 120);
INSERT INTO IngredientsLevel
VALUES (88.5, 39.25, 105.50);
INSERT INTO IngredientsLevel
VALUES (10.0, 30.5, 50.0);

INSERT INTO Orders
VALUES ('ORDER01', 'CUS24', '0332567890', '12 Street Lakemba 2294', 'Takeaway', '2019-10-11  09:0:0', '2019-10-11  09:15:0', '2 Items for $23.75', 'Cash', 'Confirmed', 'Add extra cheese', '2019-10-11  09:15:00');
INSERT INTO Orders
VALUES ('ORDER02', 'CUS56', '0223556774', '55A Turntin Rd Lakemba 2294', 'Dine In', '2019-10-12  10:0:0', '2019-10-12  10:15:0', '4 Items for $43.55', 'Cash', 'Not Confirmed', 'Serve in plastic plates', '2019-10-12  10:15:00');
INSERT INTO Orders
VALUES ('ORDER03', 'CUS88', '0445776772', 'Huxley Squares Auburn 2244', 'Takeaway', '2019-10-11  14:0:0', '2019-10-11  14:25:0', '1 Item for $9.75', 'Card', 'Pending', 'Add extra chilli flakes', '2019-10-11  14:25:00');

INSERT INTO WalkInOrder
VALUES ('ORDER01', '2019-10-11  09:0:0');
INSERT INTO WalkInOrder
VALUES ('ORDER02', '2019-10-12  10:0:0');
INSERT INTO WalkInOrder
VALUES ('ORDER03', '2019-10-13  11:20:0');

INSERT INTO PhoneOrder
VALUES ('ORDER01', '2019-10-11  20:0:0', '2019-10-11  20:09:0');
INSERT INTO PhoneOrder
VALUES ('ORDER02', '2019-10-12  09:0:0', '2019-10-12  09:05:0');
INSERT INTO PhoneOrder
VALUES ('ORDER03', '2019-10-11  15:0:0', '2019-10-11  15:12:0');

INSERT INTO Delivery
VALUES ('ORDER01', '02A Naghton Ave Brookshill 2288', '2019-10-19  14:05:0');
INSERT INTO Delivery
VALUES ('ORDER02', '88 Flesh Lane Sydney 2278', '2019-10-20  19:10:0');
INSERT INTO Delivery
VALUES ('ORDER03', '02A Naghton Ave Brookshill 2288', '2019-10-20  16:55:0');

INSERT INTO Pickup
VALUES ('ORDER01', '2019-10-22  18:23:0');
INSERT INTO Pickup
VALUES ('ORDER02', '2019-10-03  09:20:0');
INSERT INTO Pickup
VALUES ('ORDER03', '2019-10-18  22:02:0');

INSERT INTO EmployeePayDetails
VALUES ('EMP87039', 1201.89, 179.85, 1032.20, '0554893', '2019-10-07  12:0:0', '2019-10-14  12:0:0');
INSERT INTO EmployeePayDetails
VALUES ('EMP87874', 1140.89, 150.87, 990.54, '2239842', '2019-10-07  12:0:0', '2019-10-14  12:0:0');
INSERT INTO EmployeePayDetails
VALUES ('EMP89002', 998.20, 95.22, 902.12, '0887334', '2019-10-14  12:0:0', '2019-10-21  12:0:0');

INSERT INTO EmployeeBankDetails
VALUES ('0554893', 'NEWY24', 'Commonwealth Bank');
INSERT INTO EmployeeBankDetails
VALUES ('2239842', 'ANZ01', 'ANZ Bank');
INSERT INTO EmployeeBankDetails
VALUES ('0887334', 'NEWY24', 'Commonwealth Bank');

INSERT INTO DriverPay
VALUES ('EMP87039', 9.75, 22);
INSERT INTO DriverPay
VALUES ('EMP87874', 9.33, 18);
INSERT INTO DriverPay
VALUES ('EMP89002', 9.75, 31);

INSERT INTO InStorePay
VALUES ('EMP87039', 27.03, 39.75);
INSERT INTO InStorePay
VALUES ('EMP87874', 27.03, 27.90);
INSERT INTO InStorePay
VALUES ('EMP89002', '20.21', 42.50);

INSERT INTO EmployeeInfo
VALUES ('EMP44871', 'Casual', 'Sharjeel', 'Sohail', '109 University Drive', '0451645687', '051-4463-90', '336887', 27.03, 'Long tall brown guy');
INSERT INTO EmployeeInfo
VALUES ('EMP55639', 'Permanent', 'Zain', 'Abedin', '41 Mayfield Newcastle', '0322876452', '032-3343-77', '992332', 17.50, 'Old loyal employee');
INSERT INTO EmployeeInfo
VALUES ('EMP12390', 'Casual', 'Shingi', 'Chikoto', '40A Englund St Birmingham', '0453886120', '776-2678-22', '886352', 35.95, 'Tall black guy');

INSERT INTO EmployeeInfoBank
VALUES ('EMP44871', 'NEWY24', 'Commonwealth Bank');
INSERT INTO EmployeeInfoBank
VALUES ('EMP55639', 'NEWY24', 'Commonwealth Bank');
INSERT INTO EmployeeInfoBank
VALUES ('EMP12390', 'ANZ01', 'ANZ Bank');

INSERT INTO InStoreEmployee
VALUES ('EMP44871', 27.03);
INSERT INTO InStoreEmployee
VALUES ('EMP55639', 17.50);
INSERT INTO InStoreEmployee
VALUES ('EMP12390', 35.95);

INSERT INTO DriverEmployee
VALUES ('EMP66785', 'N376YY98', 6.75);
INSERT INTO DriverEmployee
VALUES ('EMP111982', 'X99IO664', 6.75);
INSERT INTO DriverEmployee
VALUES ('EMP77690', 'YYU5561M', 6.75);

INSERT INTO Shifts
VALUES ('MORNING12', '2019-10-11', '12:0:0', '2019-10-11', '20:0:0', 'Dayshift');
INSERT INTO Shifts
VALUES ('MORNING09', '2019-10-20', '09:0:0', '2019-10-20', '15:0:0', 'Dayshift');
INSERT INTO Shifts
VALUES ('NIGHT11', '2019-10-27', '11:0:0', '2019-10-28', '05:0:0', 'Overnight');

INSERT INTO InStoreShift
VALUES ('MORNING12', 'EMP87039', 'EMP44871', 8.25);
INSERT INTO InStoreShift
VALUES ('MORNING09', 'EMP87874', 'EMP55639', 5.50);
INSERT INTO InStoreShift
VALUES ('NIGHT11', 'EMP89002', 'EMP12390', 7.00);

INSERT INTO DriverShift
VALUES ('MORNING12', 'EMP87039', 'EMP66785', 14);
INSERT INTO DriverShift
VALUES ('MORNING09', 'EMP87874', 'EMP111982', 09);
INSERT INTO DriverShift
VALUES ('NIGHT11', 'EMP89002', 'EMP77690', 21);

INSERT INTO MenuItems
VALUES ('ITEM001', 'Lasangna', 'large', 18.99, 'Beef cheese lasagna');
INSERT INTO MenuItems
VALUES ('ITEM002', 'Chicken Supreme', 'large', 21.95, 'Chicken Veg pizza');
INSERT INTO MenuItems
VALUES ('ITEM003', 'Meat lover', 'Small', 12.90, 'Beef pizza with buffalo sauce');

INSERT INTO Customers
VALUES ('CUS24', 'Mitchelle', 'Elf', '99 Ulav Street Lambton', 0887556231, 'PhCustomer', 'Chicken Supreme & Meat Lover');
INSERT INTO Customers
VALUES ('CUS56', 'Micheal', 'Shelby', '22 Garrison St Laks', 0456778923, 'DCustomer', 'Chicken lasagna & Garlic bread');
INSERT INTO Customers
VALUES ('CUS88', 'Robin', 'Billy', 'Red Rose Apartments Mumbai', 0562991663, 'PhCustomer', 'Chicken Supreme');

-- % CREATING QUERIES FROM HERE %

-- Q.3 List all the order details of the orders that are made by a walk-in cusotmer with 
-- fist name Robin and last name billy between date 2019-10-08 and 2019-10-15.

SELECT  WalkInOrder.*, Orders.*
FROM Orders, Customers, WalkInOrder
WHERE Orders.OrderId = WalkInOrder.OrderId AND
	  Orders.customerId = Customers.CustomerId AND 
	  Customers.fName = 'Robin' AND
	  Customers.lName = 'Billy' AND
	  Orders.dateAndTime BETWEEN '2019-10-08' AND '2019-10-15';


-- Q.2 List all the shift details of a delivery staff with first name Sharjeel
-- and last name Sohail between 2019-10-10 and 2019-10-28

SELECT EmployeeInfo.FirstName, EmployeeInfo.LastName, Shifts.*
FROM EmployeeInfo, Shifts
WHERE EmployeeInfo.FirstName = 'Sharjeel' AND
	  EmployeeInfo.LastName = 'Sohail' AND 
	  Shifts.StartDate BETWEEN '2019-10-10' AND '2019-10-20';


-- Q.1 For an in office staff with Id number xxx, print sharjeel first name 
-- sohail as last name and pay rate.

SELECT EmployeeInfo.EmployeeNo, EmployeeInfo.FirstName,EmployeeInfo.LastName,
EmployeeInfo.PaymentRate
FROM EmployeeInfo
WHERE EmployeeInfo.EmployeeNo = 'EMP44871'

-- Q.6 List names of the ingredients that was/were supplied by the supplier id 
--  between 2019-10-28 and 2019-10-30

SELECT IngredientsOnly.IngName, IngredientOrder.arrivalDate, Suppliers.supplierCode
FROM IngredientsOnly, IngredientOrder, Suppliers
WHERE Suppliers.supplierCode = IngredientOrder.supplierCode AND 
IngredientOrder.arrivalDate BETWEEN '2019-10-28' AND '2019-10-31';

-- Q.4 Print the salary paid to a delivery staff with first name and last name in
-- in current month. Current month is decided by the system




