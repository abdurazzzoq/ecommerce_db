CREATE DATABASE ecommerce;

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50)
);

CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES Products(product_id),
    user_id INT REFERENCES Users(user_id),
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    parent_id INT REFERENCES Categories(category_id) -- allows for nesting categories
);

-- ProductCategories (junction table for Products and Categories)
CREATE TABLE ProductCategories (
    product_id INT REFERENCES Products(product_id),
    category_id INT REFERENCES Categories(category_id),
    PRIMARY KEY (product_id, category_id)
);

-- Inventory
CREATE TABLE Inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL,
    location VARCHAR(255) NOT NULL -- could be further normalized into a separate Locations table
);

-- ShippingDetails
CREATE TABLE ShippingDetails (
    shipping_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    shipped_date TIMESTAMP,
    estimated_delivery_date TIMESTAMP
);

-- PaymentTransactions
CREATE TABLE PaymentTransactions (
    transaction_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) NOT NULL, -- e.g., 'Credit Card', 'PayPal'
    status VARCHAR(50) NOT NULL -- e.g., 'Completed', 'Pending', 'Failed'
);

-- UserAddresses
CREATE TABLE UserAddresses (
    address_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    address_type VARCHAR(50) -- e.g., 'Shipping', 'Billing'
);

-- ProductVariations
CREATE TABLE ProductVariations (
    variation_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES Products(product_id),
    color VARCHAR(50),
    size VARCHAR(50),
    additional_price DECIMAL(10, 2) DEFAULT 0.00 -- Adjust price based on variation
);

-- Wishlists
CREATE TABLE Wishlists (
    wishlist_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- WishlistItems
CREATE TABLE WishlistItems (
    wishlist_item_id SERIAL PRIMARY KEY,
    wishlist_id INT REFERENCES Wishlists(wishlist_id),
    product_id INT REFERENCES Products(product_id)
);

-- CustomerServiceInquiries
CREATE TABLE CustomerServiceInquiries (
    inquiry_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(50) NOT NULL, -- e.g., 'Open', 'Resolved'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- InquiryResponses
CREATE TABLE InquiryResponses (
    response_id SERIAL PRIMARY KEY,
    inquiry_id INT REFERENCES CustomerServiceInquiries(inquiry_id),
    responder_id INT REFERENCES Users(user_id), -- Assuming employees are also in Users table
    response TEXT NOT NULL,
    response_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ProductRecommendations
CREATE TABLE ProductRecommendations (
    recommendation_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    product_id INT REFERENCES Products(product_id),
    reason VARCHAR(255), -- e.g., 'Based on your browsing history'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- LoyaltyProgramMembers
CREATE TABLE LoyaltyProgramMembers (
    membership_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    points INT DEFAULT 0,
    level VARCHAR(50), -- e.g., 'Silver', 'Gold', 'Platinum'
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- OrderTracking
CREATE TABLE OrderTracking (
    tracking_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    status VARCHAR(255) NOT NULL, -- e.g., 'Shipped', 'In Transit', 'Delivered'
    location VARCHAR(255),
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Suppliers
CREATE TABLE Suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    phone_number VARCHAR(50),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

-- Warehouses
CREATE TABLE Warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

-- WarehouseStock
CREATE TABLE WarehouseStock (
    stock_id SERIAL PRIMARY KEY,
    warehouse_id INT REFERENCES Warehouses(warehouse_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL
);

-- ProductReturns
CREATE TABLE ProductReturns (
    return_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL,
    reason TEXT,
    return_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) -- e.g., 'Received', 'Processing', 'Refunded'
);
