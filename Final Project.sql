--Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.

select cs.name_of_school, cs.COMMUNITY_AREA_NAME,cs.AVERAGE_STUDENT_ATTENDANCE
from CHICAGO_PUBLIC_SCHOOLS cs left join census_data cd 
on cs.community_area_number = cd.community_area_number  
where hardship_index = 98

--Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name.

select cc.case_number, cc.primary_type, cd.community_area_number
from chicago_crime_data cc left join census_data cd 
on cc.community_area_number = cd.community_area_number  
where cc.location_description like 'SCHOOL%'

--Write and execute a SQL statement to create a view showing the columns listed in the following table, with new column names as shown in the second column.

DROP VIEW school_view;
create view school_view as 
select NAME_OF_SCHOOL as School_Name,
		Safety_Icon as Safety_Rating,
		Family_Involvement_Icon AS Family_Rating,
		Environment_Icon AS Environment_Rating,
		Instruction_Icon AS Instruction_Rating,
		Leaders_Icon as Leaders_Rating,
		Teachers_Icon as Teachers_Rating
from CHICAGO_PUBLIC_SCHOOLS cp;


--Write and execute a SQL statement that returns all of the columns from the view.

select * from SCHOOLS_VIEW;

--Write and execute a SQL statement that returns just the school name and leaders rating from the view.

SELECT School_Name, Leaders_Rating FROM school_view;

--Write the structure of a query to create or replace a stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as an integer 
--and a in_Leader_Score parameter as an integer. Don't forget to use the #SET TERMINATOR statement to use the @ for the CREATE statement terminator.

--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_LEADERS_SCORE( 
    IN in_School_ID INTEGER, IN in_Leaders_Score Integer )     -- ( { IN/OUT type } { parameter-name } { data-type }, ... )

LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN 

END
@
  
--Inside your stored procedure, write a SQL statement to update the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified 
--by in_School_ID to the value in the in_Leader_Score parameter.

DROP PROCEDURE UPDATE_LEADERS_SCORE;

--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_LEADERS_SCORE( 
    IN in_School_ID INTEGER, IN in_Leaders_Score Integer )     -- ( { IN/OUT type } { parameter-name } { data-type }, ... )

LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN 
	
	Update CHICAGO_PUBLIC_SCHOOLS
	SET Leaders_Score = in_Leaders_Score
	where SCHOOL_ID = in_SCHOOL_ID;
  
 END
 @
 
--Inside your stored procedure, write a SQL IF statement to update the Leaders_Icon field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified
--by in_School_ID using the following information.

DROP PROCEDURE UPDATE_LEADERS_SCORE;

--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_LEADERS_SCORE( 
    IN in_School_ID INTEGER, IN in_Leaders_Score Integer )     -- ( { IN/OUT type } { parameter-name } { data-type }, ... )

LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN 
	
	Update CHICAGO_PUBLIC_SCHOOLS
	SET Leaders_Score = in_Leaders_Score
	where SCHOOL_ID = in_SCHOOL_ID;
	
	IF (in_Leaders_Score > 0 AND in_Leaders_Score < 20) THEN                      -- Start of conditional statement
        UPDATE CHICAGO_PUBLIC_SCHOOLS 
        SET Leaders_icon = 'Very weak'
        WHERE School_ID = in_School_ID;
        
    ELSEIF in_Leaders_Score < 40 THEN
    	UPDATE CHICAGO_PUBLIC_SCHOOLS 
        SET Leaders_icon = 'weak'
        WHERE School_ID = in_School_ID;
    	
    ELSEIF in_Leaders_Score < 60 THEN
    	UPDATE CHICAGO_PUBLIC_SCHOOLS 
        SET Leaders_icon = 'Average'
        WHERE School_ID = in_School_ID;
 
 	ELSEIF in_Leaders_Score < 80 THEN
 		UPDATE CHICAGO_PUBLIC_SCHOOLS 
        SET Leaders_icon = 'Strong'
        WHERE School_ID = in_School_ID;
 	
 	ELSEIF in_Leaders_Score < 100 THEN
 		UPDATE CHICAGO_PUBLIC_SCHOOLS 
        SET Leaders_icon = 'Very Strong'
        WHERE School_ID = in_School_ID;

   END IF;                 
END
@                                               -- Routine termination character

--Write a query to call the stored procedure, passing a valid school ID and a leader score of 50, to check that the procedure works as expected

select SCHOOL_ID, Leaders_icon from CHICAGO_PUBLIC_SCHOOLS where SCHOOL_ID =609760;

CALL UPDATE_LEADERS_SCORE(609760,50);

select SCHOOL_ID, Leaders_icon from CHICAGO_PUBLIC_SCHOOLS where SCHOOL_ID =609760;

--Update your stored procedure definition. Add a generic ELSE clause to the IF statement that rolls back the current work if the score did not fit any of the preceding categories.
--Update your stored procedure definition again. Add a statement to commit the current unit of work at the end of the procedure.

DROP PROCEDURE UPDATE_LEADERS_SCORE;

--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_LEADERS_SCORE( 
    IN in_School_ID INTEGER, IN in_Leaders_Score Integer )     -- ( { IN/OUT type } { parameter-name } { data-type }, ... )

LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN 
	
	Update CHICAGO_PUBLIC_SCHOOLS
	SET Leaders_Score = in_Leaders_Score
	where SCHOOL_ID = in_SCHOOL_ID;
	
	IF (in_Leaders_Score > 0 AND in_Leaders_Score < 20) THEN                      -- Start of conditional statement
        UPDATE CHICAGO_PUBLIC_SCHOOLS 
        SET Leaders_icon = 'Very weak'
        WHERE School_ID = in_School_ID;
        
    ELSEIF in_Leaders_Score < 40 THEN
    	UPDATE CHICAGO_PUBLIC_SCHOOLS 
        SET Leaders_icon = 'weak'
        WHERE School_ID = in_School_ID;
    	
    ELSEIF in_Leaders_Score < 60 THEN
    	UPDATE CHICAGO_PUBLIC_SCHOOLS 
        SET Leaders_icon = 'Average'
        WHERE School_ID = in_School_ID;
 
 	ELSEIF in_Leaders_Score < 80 THEN
 		UPDATE CHICAGO_PUBLIC_SCHOOLS 
        SET Leaders_icon = 'Strong'
        WHERE School_ID = in_School_ID;
 	
 	ELSEIF in_Leaders_Score < 100 THEN
 		UPDATE CHICAGO_PUBLIC_SCHOOLS 
        SET Leaders_icon = 'Very Strong'
        WHERE School_ID = in_School_ID;
    ELSE 
    	ROLLBACK WORK;
    END IF;                 
    COMMIT WORK;
END
@                                                             -- Routine termination character

--Run your code to replace the stored procedure.
--NOTE: I had to alter column to be able to run procedure using following command: 
ALTER TABLE CHICAGO_PUBLIC_SCHOOLS ALTER COLUMN "Leaders_Icon" SET DATA TYPE VARCHAR(11)

--Write and run one query to check that the updated stored procedure works as expected when you use a valid score of 38.
--Write and run another query to check that the updated stored procedure works as expected when you use an invalid score of 101.

select SCHOOL_ID, Leaders_icon from CHICAGO_PUBLIC_SCHOOLS where SCHOOL_ID =609760 ;

CALL UPDATE_LEADERS_SCORE(609760, 38);

select SCHOOL_ID, Leaders_icon from CHICAGO_PUBLIC_SCHOOLS where SCHOOL_ID =609760 ;

CALL UPDATE_LEADERS_SCORE(609760, 101);

select SCHOOL_ID, Leaders_icon from CHICAGO_PUBLIC_SCHOOLS where SCHOOL_ID =609760 ;