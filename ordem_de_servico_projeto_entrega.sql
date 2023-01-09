-- CRIAR DATABASE ORDEM DE SERVIÇOS OFICINA
-- CREATE DATABASE ORDEM_SERVICO;
USE ORDEM_SERVICO;

CREATE TABLE CLIENTS(
	idClient int auto_increment primary key,
    cName VARCHAR(45),
    address VARCHAR(45),
    cpf CHAR(11),
    phone CHAR(11),
    constraint unique_cpf_client unique (cpf)
);


INSERT INTO 
CLIENTS(cName, address, cpf, phone) VALUES
('CLOE ALBERTO DE SOUZA', 'RUA BOLIVIA, 200 - PRAIA GRANDE', 21447469848, 11984526957),
('VALENTINA DE SOUZA', 'RUA HONDURAS, 100 - PRAIA GRANDE', 21447469852, 11984526987),
('AGATHA CORDEIRO', 'RUA CHILE, 250 - PRAIA GRANDE', 31447469850, 11974526996),
('SUSANA BERGAMO', 'RUA BRASIL, 300 - PRAIA GRANDE', 41447469888, 11974526988),
('RAMONA SIMOES', 'RUA CHIPRE, 280 - PRAIA GRANDE', 37447469855, 11945269344);

SELECT * FROM CLIENTS;


CREATE TABLE SERVICE_ORDER(
	idSorder int auto_increment primary key,
    idClient int,
    vehicleModel VARCHAR(45),
    vehiclePlate VARCHAR(45),
    idStype int,
    idMechanic int,
    serviceStatus varchar(45),
    deliveryDeadline date,
    constraint fk_serviceorder_clients foreign key(idClient) references CLIENTS(idClient)
    );
    
    
INSERT INTO SERVICE_ORDER(idClient, vehicleModel, vehiclePlate, idStype, idMechanic, serviceStatus, deliveryDeadline) VALUES
	(1, 'HIUNDAY CRETA', 'CLO1982', 1, 1, 'EM MANUTENÇÃO', '2023-01-20'),
    (1, 'HIUNDAY CRETA', 'CLO1982', 4, 2, 'SERVIÇO FINALIZADO', '2023-01-20'),
    (2, 'HONDA CIVIC','SUS1986' , 4, 4, 'EM MANUTENÇÃO', '2023-01-25'),
    (1, 'HIUNDAY CRETA', 'CLO1982', 3, 3, 'SERVIÇO FINALIZADO', '2023-01-26');
    
select * from SERVICE_ORDER;
	

CREATE TABLE SERVICE_LIST(
	idStype INT AUTO_INCREMENT PRIMARY KEY,
    serviceName VARCHAR(100),
    servicePrice DECIMAL
    );


INSERT INTO SERVICE_LIST(serviceName, servicePrice) VALUES
	('TROCA DE EMBREAGEM', 5000.00),
    ('SUBSTITUIÇÃO DE BOMBA DE COMBUSTIVEL',300.00),
    ('RETIFICA DE MOTOR', 6000.00),
    ('MANUTENÇÃO DE CAMBIO MANUAL', 7000.00),
    ('BALANCEAMENTO DE RODAS', 900.00);
    
SELECT * FROM SERVICE_LIST;
    

CREATE TABLE PAYMENT(
	idPayment int auto_increment primary key,
    idClient int,
    paymentType enum('PIX', 'CARTÃO DE CRÉDITO', 'CARTÃO DE DÉBITO', 'DINHEIRO'),
    paymentStatus enum('Em processamento', 'Aprovado', 'Recusado'),
    constraint fk_payment_clients foreign key(idClient) references CLIENTS(idClient),
    constraint fk_payment_serviceorder foreign key(idClient) references SERVICE_ORDER(idClient)
    );
    
    
INSERT INTO PAYMENT(idClient, paymentType, paymentStatus) VALUES
	(1, 'PIX','Aprovado'),
    (1, 'CARTÃO DE CRÉDITO', 'Aprovado'),
    (2, 'CARTÃO DE DÉBITO', 'Recusado'),
    (1, 'DINHEIRO', 'Aprovado');

SELECT * FROM PAYMENT;

CREATE TABLE MECHANIC(
	idMechanic int auto_increment primary key,
    mechanicName varchar(45),
    mechanicSpeciality varchar(45),
    constraint fk_mechanic_serviceorder foreign key(idMechanic) references SERVICE_ORDER(idSorder)    

);

INSERT INTO MECHANIC(mechanicName, mechanicSpeciality) VALUES
	('TITE FALABUTTO', 'ESPECIALISTA EM MOTOR'),
    ('IRIS LOVE', 'ESPECIALISTA EM CAMBIO'),
    ('TATHA MARTINEZ', 'ESPECIALISTA EM ALINHAMENTO'),
    ('JULLY NAYDA', 'ESPECIALISTA EM AUTO-ELETRICA');
    
    
-- QUERY SELECIONA OS DADOS COMPLETOS DAS ORDENS DE SERVIÇO EM ABERTO, ORDENADO POR NUMERO DE ABERTURA

SELECT S.idSorder, C.idClient, C.cName, S.vehicleModel, S.vehiclePlate, S.idStype, L.serviceName, S.serviceStatus, L.servicePrice, S.idMechanic, M.mechanicName
	FROM CLIENTS as C
	JOIN SERVICE_ORDER as S
	ON C.idClient = S.idClient
	JOIN SERVICE_LIST as L
	ON S.idStype = L.idStype
	JOIN MECHANIC as M
	ON S.idMechanic = M.idMechanic
	ORDER BY idSorder;

-- seleciona os dados da ORDEM DE SERVIÇO COM STATUS FINALIZADO
SELECT C.idClient, C.cName, S.vehicleModel, S.vehiclePlate, S.idStype, L.serviceName, S.serviceStatus, L.servicePrice, S.idMechanic, M.mechanicName
	FROM CLIENTS as C
	JOIN SERVICE_ORDER as S
	ON C.idClient = S.idClient
	JOIN SERVICE_LIST as L
	ON S.idStype = L.idStype
	JOIN MECHANIC as M
	ON S.idMechanic = M.idMechanic
	WHERE S.serviceStatus = 'SERVIÇO FINALIZADO';

-- SELECIONA DADOS DA ORDEM DE SERVIÇO, COM STATUS E DADOS DE PAGAMENTO
SELECT S.idSorder, C.idClient, C.cName, S.vehicleModel, S.vehiclePlate, S.idStype, L.serviceName, S.serviceStatus, L.servicePrice, S.idMechanic, M.mechanicName, P.paymentType, P.paymentStatus
	FROM CLIENTS as C
	JOIN SERVICE_ORDER as S
	ON C.idClient = S.idClient
	JOIN SERVICE_LIST as L
	ON S.idStype = L.idStype
	JOIN MECHANIC as M
	ON S.idMechanic = M.idMechanic
	JOIN PAYMENT AS P
	ON S.idClient = P.idClient
	GROUP BY S.idSorder;


    