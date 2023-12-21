-- MariaDB dump 10.19-11.1.2-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: seguiorden
-- ------------------------------------------------------
-- Server version	11.1.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Clientes`
--

DROP TABLE IF EXISTS `Clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Clientes` (
  `RFC` char(13) NOT NULL,
  `Nombre` varchar(255) DEFAULT NULL,
  `Direccion` varchar(255) DEFAULT NULL,
  `CoordenadaID` int(11) DEFAULT NULL,
  PRIMARY KEY (`RFC`),
  KEY `CoordenadaID` (`CoordenadaID`),
  CONSTRAINT `Clientes_ibfk_1` FOREIGN KEY (`CoordenadaID`) REFERENCES `Coordenadas` (`IDCoordenada`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Clientes`
--

LOCK TABLES `Clientes` WRITE;
/*!40000 ALTER TABLE `Clientes` DISABLE KEYS */;
INSERT INTO `Clientes` VALUES
('KHKJASK','Carlos Arce','La Comunidad',1);
/*!40000 ALTER TABLE `Clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Coordenadas`
--

DROP TABLE IF EXISTS `Coordenadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Coordenadas` (
  `IDCoordenada` int(11) NOT NULL AUTO_INCREMENT,
  `Latitud` decimal(10,6) DEFAULT NULL,
  `Longitud` decimal(10,6) DEFAULT NULL,
  PRIMARY KEY (`IDCoordenada`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Coordenadas`
--

LOCK TABLES `Coordenadas` WRITE;
/*!40000 ALTER TABLE `Coordenadas` DISABLE KEYS */;
INSERT INTO `Coordenadas` VALUES
(1,19.156565,20.446456);
/*!40000 ALTER TABLE `Coordenadas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DetalleProduccion`
--

DROP TABLE IF EXISTS `DetalleProduccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DetalleProduccion` (
  `IDDetalleProduccion` int(11) NOT NULL AUTO_INCREMENT,
  `IDProducto` int(11) DEFAULT NULL,
  `IDMaterial` int(11) DEFAULT NULL,
  `CantidadUtilizada` int(11) DEFAULT NULL,
  PRIMARY KEY (`IDDetalleProduccion`),
  KEY `IDProducto` (`IDProducto`),
  KEY `IDMaterial` (`IDMaterial`),
  CONSTRAINT `fk_material_detalle` FOREIGN KEY (`IDMaterial`) REFERENCES `Materiales` (`IDMaterial`),
  CONSTRAINT `fk_producto_detalle` FOREIGN KEY (`IDProducto`) REFERENCES `Productos` (`IDProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DetalleProduccion`
--

LOCK TABLES `DetalleProduccion` WRITE;
/*!40000 ALTER TABLE `DetalleProduccion` DISABLE KEYS */;
/*!40000 ALTER TABLE `DetalleProduccion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Materiales`
--

DROP TABLE IF EXISTS `Materiales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Materiales` (
  `IDMaterial` int(11) NOT NULL AUTO_INCREMENT,
  `NombreMaterial` varchar(255) DEFAULT NULL,
  `Descripcion` text DEFAULT NULL,
  `PrecioUnidad` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`IDMaterial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Materiales`
--

LOCK TABLES `Materiales` WRITE;
/*!40000 ALTER TABLE `Materiales` DISABLE KEYS */;
/*!40000 ALTER TABLE `Materiales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ordenes`
--

DROP TABLE IF EXISTS `Ordenes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Ordenes` (
  `NumeroOrden` int(11) NOT NULL AUTO_INCREMENT,
  `RFCCliente` char(13) DEFAULT NULL,
  `FechaSolicitada` date DEFAULT NULL,
  `FechaEntrega` date DEFAULT NULL,
  PRIMARY KEY (`NumeroOrden`),
  KEY `RFCCliente` (`RFCCliente`),
  CONSTRAINT `Ordenes_ibfk_1` FOREIGN KEY (`RFCCliente`) REFERENCES `Clientes` (`RFC`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ordenes`
--

LOCK TABLES `Ordenes` WRITE;
/*!40000 ALTER TABLE `Ordenes` DISABLE KEYS */;
/*!40000 ALTER TABLE `Ordenes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pagos`
--

DROP TABLE IF EXISTS `Pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Pagos` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NombreArchivo` varchar(255) NOT NULL,
  `Estatus` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pagos`
--

LOCK TABLES `Pagos` WRITE;
/*!40000 ALTER TABLE `Pagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `Pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PeticionesMateriaPrima`
--

DROP TABLE IF EXISTS `PeticionesMateriaPrima`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PeticionesMateriaPrima` (
  `IDPeticion` int(11) NOT NULL AUTO_INCREMENT,
  `RFCCliente` char(13) DEFAULT NULL,
  `FechaSolicitud` date DEFAULT NULL,
  `FechaEntregaEsperada` date DEFAULT NULL,
  `IDMaterial` int(11) DEFAULT NULL,
  `CantidadSolicitada` int(11) DEFAULT NULL,
  `EstatusPeticion` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IDPeticion`),
  KEY `RFCCliente` (`RFCCliente`),
  KEY `IDMaterial` (`IDMaterial`),
  CONSTRAINT `PeticionesMateriaPrima_ibfk_1` FOREIGN KEY (`RFCCliente`) REFERENCES `Clientes` (`RFC`),
  CONSTRAINT `PeticionesMateriaPrima_ibfk_2` FOREIGN KEY (`IDMaterial`) REFERENCES `Materiales` (`IDMaterial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PeticionesMateriaPrima`
--

LOCK TABLES `PeticionesMateriaPrima` WRITE;
/*!40000 ALTER TABLE `PeticionesMateriaPrima` DISABLE KEYS */;
/*!40000 ALTER TABLE `PeticionesMateriaPrima` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Productos`
--

DROP TABLE IF EXISTS `Productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Productos` (
  `IDProducto` int(11) NOT NULL AUTO_INCREMENT,
  `NombreProducto` varchar(255) DEFAULT NULL,
  `Descripcion` text DEFAULT NULL,
  `Precio` decimal(10,2) DEFAULT NULL,
  `DescripcionProducto` text DEFAULT NULL,
  `NumeroProducto` varchar(255) DEFAULT NULL,
  `Unidades` int(11) DEFAULT 0,
  PRIMARY KEY (`IDProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Productos`
--

LOCK TABLES `Productos` WRITE;
/*!40000 ALTER TABLE `Productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `Productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Proveedores`
--

DROP TABLE IF EXISTS `Proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Proveedores` (
  `IDProveedor` int(11) NOT NULL AUTO_INCREMENT,
  `NombreProveedor` varchar(255) DEFAULT NULL,
  `DireccionProveedor` varchar(255) DEFAULT NULL,
  `Contacto` varchar(100) DEFAULT NULL,
  `CoordenadaID` int(11) DEFAULT NULL,
  PRIMARY KEY (`IDProveedor`),
  KEY `CoordenadaID` (`CoordenadaID`),
  CONSTRAINT `Proveedores_ibfk_1` FOREIGN KEY (`CoordenadaID`) REFERENCES `Coordenadas` (`IDCoordenada`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Proveedores`
--

LOCK TABLES `Proveedores` WRITE;
/*!40000 ALTER TABLE `Proveedores` DISABLE KEYS */;
/*!40000 ALTER TABLE `Proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RelacionProveedoresMateriales`
--

DROP TABLE IF EXISTS `RelacionProveedoresMateriales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RelacionProveedoresMateriales` (
  `IDRelacion` int(11) NOT NULL AUTO_INCREMENT,
  `IDProveedor` int(11) DEFAULT NULL,
  `IDMaterial` int(11) DEFAULT NULL,
  `PrecioProveedor` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`IDRelacion`),
  KEY `IDProveedor` (`IDProveedor`),
  KEY `IDMaterial` (`IDMaterial`),
  CONSTRAINT `RelacionProveedoresMateriales_ibfk_1` FOREIGN KEY (`IDProveedor`) REFERENCES `Proveedores` (`IDProveedor`),
  CONSTRAINT `RelacionProveedoresMateriales_ibfk_2` FOREIGN KEY (`IDMaterial`) REFERENCES `Materiales` (`IDMaterial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RelacionProveedoresMateriales`
--

LOCK TABLES `RelacionProveedoresMateriales` WRITE;
/*!40000 ALTER TABLE `RelacionProveedoresMateriales` DISABLE KEYS */;
/*!40000 ALTER TABLE `RelacionProveedoresMateriales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SeguimientoOrdenes`
--

DROP TABLE IF EXISTS `SeguimientoOrdenes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SeguimientoOrdenes` (
  `IDSeguimiento` int(11) NOT NULL AUTO_INCREMENT,
  `NumeroOrden` int(11) DEFAULT NULL,
  `IDMaterial` int(11) DEFAULT NULL,
  `Folio` varchar(255) DEFAULT NULL,
  `Comentarios` text DEFAULT NULL,
  `Cantidad` int(11) DEFAULT NULL,
  `Obra` varchar(255) DEFAULT NULL,
  `Estatus` varchar(50) DEFAULT NULL,
  `Entregada` tinyint(1) DEFAULT NULL,
  `Restante` int(11) DEFAULT NULL,
  `Remision` varchar(255) DEFAULT NULL,
  `IDProducto` int(11) DEFAULT NULL,
  PRIMARY KEY (`IDSeguimiento`),
  KEY `NumeroOrden` (`NumeroOrden`),
  KEY `IDMaterial` (`IDMaterial`),
  KEY `fk_producto_nuevo` (`IDProducto`),
  CONSTRAINT `SeguimientoOrdenes_ibfk_1` FOREIGN KEY (`NumeroOrden`) REFERENCES `Ordenes` (`NumeroOrden`),
  CONSTRAINT `SeguimientoOrdenes_ibfk_2` FOREIGN KEY (`IDMaterial`) REFERENCES `Materiales` (`IDMaterial`),
  CONSTRAINT `fk_producto_nuevo` FOREIGN KEY (`IDProducto`) REFERENCES `Productos` (`IDProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SeguimientoOrdenes`
--

LOCK TABLES `SeguimientoOrdenes` WRITE;
/*!40000 ALTER TABLE `SeguimientoOrdenes` DISABLE KEYS */;
/*!40000 ALTER TABLE `SeguimientoOrdenes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VitacoraGalvanizado`
--

DROP TABLE IF EXISTS `VitacoraGalvanizado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `VitacoraGalvanizado` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Fecha` date DEFAULT NULL,
  `Remision` varchar(255) DEFAULT NULL,
  `OrdenDeTrabajo` int(11) DEFAULT NULL,
  `Factura` varchar(255) DEFAULT NULL,
  `Folio` varchar(255) DEFAULT NULL,
  `Producto` varchar(255) DEFAULT NULL,
  `Cantidad` int(11) DEFAULT NULL,
  `ParcialidadRecolectada` int(11) DEFAULT NULL,
  `Recoleccion` varchar(255) DEFAULT NULL,
  `Peso` decimal(10,2) DEFAULT NULL,
  `Costo` decimal(10,2) DEFAULT NULL,
  `Estatus` varchar(50) DEFAULT NULL,
  `NumeroOrden` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_numero_orden` (`NumeroOrden`),
  CONSTRAINT `fk_numero_orden` FOREIGN KEY (`NumeroOrden`) REFERENCES `Ordenes` (`NumeroOrden`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VitacoraGalvanizado`
--

LOCK TABLES `VitacoraGalvanizado` WRITE;
/*!40000 ALTER TABLE `VitacoraGalvanizado` DISABLE KEYS */;
INSERT INTO `VitacoraGalvanizado` VALUES
(1,'2023-08-23','3695',NULL,'FA58346','TLAXCALA','TRAVESAÑO DE 1.14 MTS',21,NULL,'28-08-23',8325.00,4442.22,'RECOLECTADO',NULL),
(2,'2023-08-23','3695',NULL,'FA58346','TLAXCALA','TRAVESAÑO DE 0.30 MTS',277,NULL,'28-08-23',NULL,NULL,'RECOLECTADO',NULL);
/*!40000 ALTER TABLE `VitacoraGalvanizado` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-09  9:24:20
