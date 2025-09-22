CREATE TABLE Clientes (
  ClienteID INT PRIMARY KEY,
  Nombre VARCHAR(100),
  Email VARCHAR(150),
  Pais VARCHAR(50)
);

CREATE TABLE Productos (
  ProductoID INT PRIMARY KEY,
  Nombre VARCHAR(100),
  Categoria VARCHAR(50),
  Precio DECIMAL(10,2)
);

CREATE TABLE Pedidos (
  PedidoID INT PRIMARY KEY,
  Fecha DATE,
  ClienteID INT,
  ProductoID INT,
  Cantidad INT
);