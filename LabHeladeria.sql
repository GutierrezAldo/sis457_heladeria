-- ============================================================================
-- PROYECTO: Sis457Heladeria
-- BASE DE DATOS: LabHeladeria
-- DESCRIPCIÓN: Script DDL y Semilla para Heladería Artesanal NOVA
-- FECHA: Octubre 2026
-- ============================================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'LabHeladeria')
BEGIN
    ALTER DATABASE LabHeladeria SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LabHeladeria;
END
GO

CREATE DATABASE LabHeladeria
COLLATE Latin1_General_CI_AS;
GO

USE LabHeladeria;
GO

-- ============================================================================
-- 1. TABLA: Empleado
-- ============================================================================
CREATE TABLE Empleado (
    id INT IDENTITY(1,1) NOT NULL,
    cedulaIdentidad VARCHAR(20) NOT NULL,
    nombres VARCHAR(50) NOT NULL,
    primerApellido VARCHAR(50) NOT NULL,
    segundoApellido VARCHAR(50) NULL,
    cargo VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    registroActivo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Empleado PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT UQ_Empleado_CI UNIQUE (cedulaIdentidad)
);
GO

-- ============================================================================
-- 2. TABLA: Usuario
-- ============================================================================
CREATE TABLE Usuario (
    id INT IDENTITY(1,1) NOT NULL,
    idEmpleado INT NOT NULL,
    usuario VARCHAR(30) NOT NULL,
    clave VARCHAR(64) NOT NULL, -- Almacena Hash SHA-256 (64 hex characters)
    rol VARCHAR(30) NOT NULL,   -- 'Administrador', 'Cajero', 'Almacenero'
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    registroActivo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Usuario PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT UQ_Usuario_Username UNIQUE (usuario),
    CONSTRAINT UQ_Usuario_Empleado UNIQUE (idEmpleado),
    CONSTRAINT FK_Usuario_Empleado FOREIGN KEY (idEmpleado) REFERENCES Empleado(id)
);
GO

-- ============================================================================
-- 3. TABLA: Categoria
-- ============================================================================
CREATE TABLE Categoria (
    id INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200) NULL,
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    registroActivo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Categoria PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT UQ_Categoria_Nombre UNIQUE (nombre)
);
GO

-- ============================================================================
-- 4. TABLA: Presentacion
-- ============================================================================
CREATE TABLE Presentacion (
    id INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL, -- 'Cono Simple', 'Cono Doble', 'Vaso 250ml', 'Copa NOVA', 'Pote 1 Litro'
    descripcion VARCHAR(200) NULL,
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    registroActivo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Presentacion PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT UQ_Presentacion_Nombre UNIQUE (nombre)
);
GO

-- ============================================================================
-- 5. TABLA: Producto (Helados / Artículos de Mostrador)
-- ============================================================================
CREATE TABLE Producto (
    id INT IDENTITY(1,1) NOT NULL,
    idCategoria INT NOT NULL,
    idPresentacion INT NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250) NULL,
    precioVenta DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    registroActivo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Producto PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT UQ_Producto_Codigo UNIQUE (codigo),
    CONSTRAINT CHK_Producto_Precio CHECK (precioVenta >= 0),
    CONSTRAINT CHK_Producto_Stock CHECK (stock >= 0),
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY (idCategoria) REFERENCES Categoria(id),
    CONSTRAINT FK_Producto_Presentacion FOREIGN KEY (idPresentacion) REFERENCES Presentacion(id)
);
GO

-- ============================================================================
-- 6. TABLA: Cliente
-- ============================================================================
CREATE TABLE Cliente (
    id INT IDENTITY(1,1) NOT NULL,
    cedulaIdentidad VARCHAR(20) NOT NULL, -- CI / NIT boliviano
    razonSocial VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    registroActivo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Cliente PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT UQ_Cliente_CI UNIQUE (cedulaIdentidad)
);
GO

-- ============================================================================
-- 7. TABLA: Proveedor
-- ============================================================================
CREATE TABLE Proveedor (
    id INT IDENTITY(1,1) NOT NULL,
    nit VARCHAR(25) NOT NULL,
    razonSocial VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    contacto VARCHAR(50) NULL,
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    registroActivo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Proveedor PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT UQ_Proveedor_NIT UNIQUE (nit)
);
GO

-- ============================================================================
-- 8. TABLA: Venta (Transacción Cabecera)
-- ============================================================================
CREATE TABLE Venta (
    id INT IDENTITY(1,1) NOT NULL,
    idCliente INT NOT NULL,
    idUsuario INT NOT NULL,
    numeroFactura VARCHAR(20) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    total DECIMAL(12,2) NOT NULL DEFAULT 0,
    metodoPago VARCHAR(30) NOT NULL DEFAULT 'Efectivo', -- 'Efectivo', 'QR Simple', 'Tarjeta Débito'
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    registroActivo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Venta PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT UQ_Venta_Numero UNIQUE (numeroFactura),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(id),
    CONSTRAINT FK_Venta_Usuario FOREIGN KEY (idUsuario) REFERENCES Usuario(id)
);
GO

-- ============================================================================
-- 9. TABLA: DetalleVenta (Transacción Detalle)
-- ============================================================================
CREATE TABLE DetalleVenta (
    id INT IDENTITY(1,1) NOT NULL,
    idVenta INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL,
    precioUnitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    descuento DECIMAL(10,2) NOT NULL DEFAULT 0,
    total DECIMAL(12,2) NOT NULL,
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    registroActivo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT PK_DetalleVenta PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT CHK_DetalleVenta_Cantidad CHECK (cantidad > 0),
    CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (idVenta) REFERENCES Venta(id),
    CONSTRAINT FK_DetalleVenta_Producto FOREIGN KEY (idProducto) REFERENCES Producto(id)
);
GO

-- ============================================================================
-- 10. TABLA: Compra (Abastecimiento Cabecera)
-- ============================================================================
CREATE TABLE Compra (
    id INT IDENTITY(1,1) NOT NULL,
    idProveedor INT NOT NULL,
    idUsuario INT NOT NULL,
    numeroDocumento VARCHAR(30) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    total DECIMAL(12,2) NOT NULL DEFAULT 0,
    estado VARCHAR(20) NOT NULL DEFAULT 'Completado',
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    registroActivo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Compra PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT FK_Compra_Proveedor FOREIGN KEY (idProveedor) REFERENCES Proveedor(id),
    CONSTRAINT FK_Compra_Usuario FOREIGN KEY (idUsuario) REFERENCES Usuario(id)
);
GO

-- ============================================================================
-- 11. TABLA: DetalleCompra (Abastecimiento Detalle)
-- ============================================================================
CREATE TABLE DetalleCompra (
    id INT IDENTITY(1,1) NOT NULL,
    idCompra INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL,
    precioUnitario DECIMAL(10,2) NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    registroActivo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT PK_DetalleCompra PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT CHK_DetalleCompra_Cantidad CHECK (cantidad > 0),
    CONSTRAINT FK_DetalleCompra_Compra FOREIGN KEY (idCompra) REFERENCES Compra(id),
    CONSTRAINT FK_DetalleCompra_Producto FOREIGN KEY (idProducto) REFERENCES Producto(id)
);
GO

-- ============================================================================
-- 12. DATOS SEMILLA (Seed Data de Prueba Inicial)
-- ============================================================================

-- Empleado Administrador y Personal Base
INSERT INTO Empleado (cedulaIdentidad, nombres, primerApellido, segundoApellido, cargo, telefono, direccion)
VALUES 
('1029384-CH', 'Carlos', 'Mamani', 'Quispe', 'Administrador General', '72839481', 'Av. Las Américas #340, Sucre'),
('8392019-LP', 'Mariana', 'Flores', 'Gutiérrez', 'Cajera Mostrador', '71928301', 'Calle Calvo #120, Sucre'),
('9482012-PT', 'Rodrigo', 'Paz', 'Condori', 'Encargado de Producción', '73849102', 'Calle Junín #554, Sucre');

-- Usuario Administrador por Defecto (clave: 'Admin123*' hasheada con SHA-256)
-- Hash SHA-256 de "Admin123*": e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 (calculada en C#)
-- Para pruebas en desarrollo:
INSERT INTO Usuario (idEmpleado, usuario, clave, rol)
VALUES 
(1, 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Administrador'),
(2, 'cajero1', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Cajero');
-- Nota: La clave sembrada es 'admin' en SHA-256.

-- Categorías
INSERT INTO Categoria (nombre, descripcion)
VALUES 
('Helados Artesanales Frutales', 'Elaborados a base de agua y pulpa 100% natural de frutas bolivianas.'),
('Helados Cremosos Tradicionales', 'Elaborados a base de leche entera, crema y esencias selectas.'),
('Copas Especiales NOVA', 'Combinaciones gourmet con salsas, barquillos y toppings.'),
('Línea Sin Azúcar / Dietética', 'Helados endulzados con stevia aptos para diabéticos.');

-- Presentaciones
INSERT INTO Presentacion (nombre, descripcion)
VALUES 
('Cono Galleta Simple', 'Barquillo crocante tradicional de una porción (1 bola).'),
('Cono Galleta Doble', 'Barquillo crocante tradicional de dos porciones (2 bolas).'),
('Vasito Biodegradable 150ml', 'Envase ecológico individual con cucharita.'),
('Pote Térmico 1 Litro', 'Envase isotérmico para llevar a casa familiar.'),
('Copa de Vidrio Fantasía', 'Presentación para consumo en salón con crema chantilly y salsa.');

-- Catálogo Inicial de Productos
INSERT INTO Producto (idCategoria, idPresentacion, codigo, nombre, descripcion, precioVenta, stock)
VALUES 
(1, 1, 'HLD-MRQ-01', 'Maracuyá Silvestre (Cono Simple)', 'Helado al agua con pulpa de maracuyá de Caranavi', 8.00, 50),
(1, 2, 'HLD-TMB-02', 'Tumbo Andino (Cono Doble)', 'Helado agridulce con tumbo fresco del valle', 15.00, 45),
(2, 2, 'HLD-CHB-03', 'Chocolate Beniano 70% (Cono Doble)', 'Cacao silvestre puro del Beni con leche cremosa', 16.00, 60),
(2, 4, 'HLD-DLV-04', 'Dulce de Leche Colonial (1 Litro)', 'Pote de 1 litro para llevar con veteado de manjar', 45.00, 20),
(3, 5, 'HLD-CPN-05', 'Copa NOVA Especial', '3 bolas de helado, brownie, chantilly y licor Singani', 28.00, 15);

-- Clientes Frecuentes
INSERT INTO Cliente (cedulaIdentidad, razonSocial, telefono, email)
VALUES 
('0', 'Control Tributario / Sin Nombre', '0', 'ventas@heladerianova.bo'),
('5647382', 'Javier Mendoza Torrico', '76543210', 'javier.mendoza@gmail.com'),
('10293847012', 'Empresa Gastronómica del Sur SRL', '64532109', 'contacto@gastrosur.com.bo');

-- Proveedores
INSERT INTO Proveedor (nit, razonSocial, telefono, direccion, contacto)
VALUES 
('1020304050', 'Lácteos Chuquisaca PIL S.A.', '6451234', 'Parque Industrial s/n', 'Lic. Gonzalo Vargas'),
('2030405060', 'Distribuidora de Pulpa y Fruta El Valle', '78901234', 'Mercado Campesino Bloque C', 'Sra. Bertha Quispe');
GO
