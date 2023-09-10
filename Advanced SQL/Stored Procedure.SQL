-- DROP the existance PETSALE table 

DROP TABLE IF EXISTS PETSALE;            

 -- Let us first create the table PETSALE

CREATE TABLE PETSALE (                   
	ID INTEGER NOT NULL,
	ANIMAL VARCHAR(20),
	SALEPRICE DECIMAL(6,2),
	SALEDATE DATE,
	QUANTITY INTEGER,
	PRIMARY KEY (ID)
	);


INSERT INTO PETSALE VALUES               
(1,'Cat',450.09,'2018-05-29',9),
(2,'Dog',666.66,'2018-06-01',3),
(3,'Parrot',50.00,'2018-06-04',2),
(4,'Hamster',60.60,'2018-06-11',6),
(5,'Goldfish',48.48,'2018-06-14',24);


-- Create and Execute the 'Stored Procedure' to update data in A table 'PATESALE' on RDBMS MySQL using language SQL

DELIMITER @
CREATE PROCEDURE UPDATE_SALEPRICE ( 
   IN Animal_ID INTEGER, IN Animal_Health VARCHAR(5) )     
BEGIN 

   IF Animal_Health = 'BAD' THEN                           
       UPDATE PETSALE
       SET SALEPRICE = SALEPRICE - (SALEPRICE * 0.25)
       WHERE ID = Animal_ID;
   
   ELSEIF Animal_Health = 'WORSE' THEN
       UPDATE PETSALE
       SET SALEPRICE = SALEPRICE - (SALEPRICE * 0.5)
       WHERE ID = Animal_ID;
       
   ELSE
       UPDATE PETSALE
       SET SALEPRICE = SALEPRICE
       WHERE ID = Animal_ID;

   END IF;                                                 
   
END @

DELIMITER ;

-- Let us call the UPDATE_SALEPRICE routine

call UPDATE_SALEPRICE(1, 'BAD')


