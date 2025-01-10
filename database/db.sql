-- Bảng Categories (Danh mục sản phẩm)
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_id BIGINT REFERENCES categories(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Products (Sản phẩm)
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    category_id BIGINT REFERENCES categories(id),
    unit_price DECIMAL(15,2) NOT NULL,
    weight DECIMAL(10,2),
    dimensions VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Warehouses (Kho hàng)
CREATE TABLE warehouses (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Inventory (Tồn kho)
CREATE TABLE inventory (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id),
    warehouse_id BIGINT REFERENCES warehouses(id),
    quantity INTEGER NOT NULL DEFAULT 0,
    min_quantity INTEGER DEFAULT 0,
    max_quantity INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(product_id, warehouse_id)
);

-- Bảng Suppliers (Nhà cung cấp)
CREATE TABLE suppliers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    tax_code VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Purchase_Orders (Đơn đặt hàng)
CREATE TABLE purchase_orders (
    id BIGSERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    supplier_id BIGINT REFERENCES suppliers(id),
    warehouse_id BIGINT REFERENCES warehouses(id),
    order_date DATE NOT NULL,
    expected_date DATE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('draft', 'confirmed', 'received', 'cancelled')),
    total_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Purchase_Order_Items (Chi tiết đơn đặt hàng)
CREATE TABLE purchase_order_items (
    id BIGSERIAL PRIMARY KEY,
    purchase_order_id BIGINT REFERENCES purchase_orders(id),
    product_id BIGINT REFERENCES products(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    total_price DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Stock_Transactions (Giao dịch kho)
CREATE TABLE stock_transactions (
    id BIGSERIAL PRIMARY KEY,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('in', 'out', 'transfer')),
    reference_number VARCHAR(50),
    reference_type VARCHAR(50),
    from_warehouse_id BIGINT REFERENCES warehouses(id),
    to_warehouse_id BIGINT REFERENCES warehouses(id),
    transaction_date TIMESTAMP WITH TIME ZONE NOT NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Stock_Transaction_Items (Chi tiết giao dịch kho)
CREATE TABLE stock_transaction_items (
    id BIGSERIAL PRIMARY KEY,
    stock_transaction_id BIGINT REFERENCES stock_transactions(id),
    product_id BIGINT REFERENCES products(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(15,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for better performance
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_inventory_warehouse ON inventory(warehouse_id);
CREATE INDEX idx_purchase_orders_supplier ON purchase_orders(supplier_id);
CREATE INDEX idx_purchase_orders_warehouse ON purchase_orders(warehouse_id);
CREATE INDEX idx_purchase_order_items_order ON purchase_order_items(purchase_order_id);
CREATE INDEX idx_purchase_order_items_product ON purchase_order_items(product_id);
CREATE INDEX idx_stock_transactions_from_warehouse ON stock_transactions(from_warehouse_id);
CREATE INDEX idx_stock_transactions_to_warehouse ON stock_transactions(to_warehouse_id);
CREATE INDEX idx_stock_transaction_items_transaction ON stock_transaction_items(stock_transaction_id);
CREATE INDEX idx_stock_transaction_items_product ON stock_transaction_items(product_id);