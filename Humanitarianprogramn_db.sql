CREATE DATABASE HumanitarianProgramDB;
USE HumanitarianProgramDB;

CREATE TABLE jurisdiction_hierarchy (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE,
    level VARCHAR(20) NOT NULL,
    parent VARCHAR(30),
    FOREIGN KEY (parent) REFERENCES jurisdiction_hierarchy(name)
    ON DELETE CASCADE
);


CREATE TABLE village_locations (
    village_id INT AUTO_INCREMENT PRIMARY KEY,
    village VARCHAR(30) NOT NULL UNIQUE,
    total_population INT NOT NULL CHECK (total_population >= 0),
    FOREIGN KEY (village) REFERENCES jurisdiction_hierarchy(name)
    ON DELETE CASCADE
);

CREATE TABLE beneficiary_partner_data (
    partner_id INT AUTO_INCREMENT PRIMARY KEY,
    partner VARCHAR(30),
    village VARCHAR(30),
    beneficiaries INT,
    beneficiary_type VARCHAR(20),
    FOREIGN KEY (village) REFERENCES village_locations(village)
    ON DELETE CASCADE
);


INSERT INTO jurisdiction_hierarchy (name, level, parent) VALUES
('Nairobi','County',NULL),
('Kiambu','County',NULL),
('Mombasa','County',NULL),
('Westlands','Sub-County','Nairobi'),
('Kasarani','Sub-County','Nairobi'),
('Lari','Sub-County','Kiambu'),
('Gatundu South','Sub-County','Kiambu'),
('Kisauni','Sub-County','Mombasa'),
('Likoni','Sub-County','Mombasa'),
('Parklands','Village','Westlands'),
('Kangemi','Village','Westlands'),
('Roysambu','Village','Kasarani'),
('Githurai','Village','Kasarani'),
('Kiamwangi','Village','Lari'),
('Lari Town','Village','Lari'),
('Kamwangi','Village','Gatundu South'),
('Kisauni Town','Village','Kisauni'),
('Mtopanga','Village','Kisauni'),
('Likoni Town','Village','Likoni'),
('Shika Adabu','Village','Likoni');

INSERT INTO village_locations (village, total_population) VALUES
('Parklands',15000),
('Kangemi',18000),
('Roysambu',13000),
('Githurai',12500),
('Kiamwangi',12800),
('Lari Town',11000),
('Kamwangi',5212),
('Kisauni Town',20500),
('Mtopanga',15500),
('Likoni Town',12000),
('Shika Adabu',9000);

INSERT INTO beneficiary_partner_data (partner, village, beneficiaries, beneficiary_type) VALUES
('IRC','Parklands',1450,'Individuals'),
('NRC','Parklands',50,'Households'),
('SCI','Kangemi',1123,'Individuals'),
('IMC','Kangemi',1245,'Individuals'),
('CESVI','Roysambu',5200,'Individuals'),
('IMC','Githurai',70,'Households'),
('IRC','Githurai',2100,'Individuals'),
('SCI','Kiamwangi',1800,'Individuals'),
('IMC','Lari Town',1340,'Individuals'),
('CESVI','Kamwangi',55,'Households'),
('IRC','Kisauni Town',4500,'Individuals'),
('SCI','Kisauni Town',1670,'Individuals'),
('IMC','Mtopanga',1340,'Individuals'),
('CESVI','Likoni Town',4090,'Individuals'),
('IRC','Shika Adabu',2930,'Individuals'),
('SCI','Shika Adabu',5200,'Individuals');


SELECT 
    partner,
    SUM(
        CASE 
            WHEN beneficiary_type = 'Households' THEN beneficiaries * 5
            ELSE beneficiaries
        END
    ) AS total_beneficiaries
FROM beneficiary_partner_data
GROUP BY partner;


SELECT 
    v.village,
    SUM(b.beneficiaries) AS total,
    v.total_population
FROM village_locations v
JOIN beneficiary_partner_data b 
ON v.village = b.village
GROUP BY v.village;


SELECT partner
FROM beneficiary_partner_data
GROUP BY partner
HAVING SUM(beneficiaries) > (
    SELECT AVG(total)
    FROM (
        SELECT SUM(beneficiaries) AS total
        FROM beneficiary_partner_data
        GROUP BY partner
    ) AS avg_table
);

WITH district_summary AS (
    SELECT 
        j.parent AS district,
        SUM(b.beneficiaries) AS total_beneficiaries
    FROM beneficiary_partner_data b
    JOIN jurisdiction_hierarchy j 
    ON b.village = j.name
    GROUP BY j.parent
)
SELECT * FROM district_summary;


SELECT 
    partner,
    SUM(beneficiaries) AS total,
    RANK() OVER (ORDER BY SUM(beneficiaries) DESC) AS rank_position
FROM beneficiary_partner_data
GROUP BY partner;

CREATE VIEW district_summary AS
SELECT 
    j.parent AS district,
    SUM(b.beneficiaries) AS total_beneficiaries
FROM beneficiary_partner_data b
JOIN jurisdiction_hierarchy j 
ON b.village = j.name
GROUP BY j.parent;

SELECT * FROM district_summary;

CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER log_insert
AFTER INSERT ON beneficiary_partner_data
FOR EACH ROW
BEGIN
    INSERT INTO audit_log(action)
    VALUES ('New record added');
END$$

DELIMITER ;

INSERT INTO beneficiary_partner_data (partner, village, beneficiaries, beneficiary_type)
VALUES ('TEST','Parklands',100,'Individuals');

SELECT * FROM audit_log;

DELIMITER $$

CREATE PROCEDURE GetPartnerReport(IN partner_name VARCHAR(30))
BEGIN
    SELECT *
    FROM beneficiary_partner_data
    WHERE partner = partner_name;
END$$

DELIMITER ;

CALL GetPartnerReport('IRC');