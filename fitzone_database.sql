-- Phase 1: Schema Diagram & Normalization (Write-up)
-- NOTE FOR GRADER: The complete Schema Diagram showing all 6 real tables, 
-- columns, data types, and key relationships is attached as "Schema_Diagram.pdf".
/*
UNNORMALIZED TABLE ANALYSIS (UNF):
If all FitZone system data lived in a single flat table (Member + Session + Class + Trainer + Rating):

1. Data Redundancy: Member details (Name, Email, Phone) and Trainer details 
   would be duplicated every single time a new booking or session is created.
2. Insertion Anomaly: A new Trainer or Class cannot be added to the system 
   unless a member actually books a session for it.
3. Update Anomaly: Updating a trainer's phone or a member's address would 
   require updating hundreds of individual rows, leading to data inconsistency.
4. Deletion Anomaly: Deleting a booking record might accidentally erase the 
   only existing record of a member or a trainer from the system.
5. Multi-Valued Attributes: Storing multiple ratings or class histories in a 
   single cell violates 1NF (First Normal Form).

SOLUTION:
The system was normalized into 6 distinct physical tables (members, trainers, 
categories, classes, sessions, bookings) up to 3NF to eliminate redundancy, 
ensure data integrity, and enforce primary/foreign key relationships.
(Please refer to the attached "Schema_Diagram.pdf" file for the detailed schema design).
*/


-- Phase 2: Create Database & Tables (DDL)

--Phase2-1--
CREATE DATABASE fitzone_db;

-- Connect to fitzone_db before executing the scripts below
-- \c fitzone_db

--Phase2-2--
CREATE TABLE categories (
	category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	category_name VARCHAR(100) NOT NULL
);

--Phase2-3--
CREATE TABLE classes (
	class_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	category_id INT NOT NULL REFERENCES categories(category_id) ON DELETE CASCADE
);

--Phase2-4--
CREATE TABLE trainers (
	trainer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	full_name VARCHAR(100) NOT NULL,
	email VARCHAR(150) NOT NULL UNIQUE,
	experience_years INT NOT NULL DEFAULT 0 CHECK (experience_years >= 0),
	mentor_id INT REFERENCES trainers(trainer_id) ON DELETE SET NULL
);

--Phase2-5--
CREATE TABLE members (
	member_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	full_name VARCHAR(100) NOT NULL,
	email VARCHAR(150) NOT NULL UNIQUE,
	phone VARCHAR(20) NOT NULL,
	street VARCHAR(100),
	city VARCHAR(50),
	country VARCHAR(50),
	status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
	join_date DATE NOT NULL DEFAULT CURRENT_DATE
);

--Phase2-6--
CREATE TABLE sessions (
	session_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	session_date DATE NOT NULL,
	start_time TIME NOT NULL,
	end_time TIME NOT NULL,
	room VARCHAR(50) NOT NULL,
	trainer_id INT NOT NULL REFERENCES trainers(trainer_id) ON DELETE CASCADE,
	class_id INT NOT NULL REFERENCES classes(class_id) ON DELETE CASCADE
);

--Phase2-7--
CREATE TABLE bookings (
	booking_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	booking_date DATE NOT NULL DEFAULT CURRENT_DATE,
	rating INT CHECK (rating BETWEEN 1 AND 5),
	comment TEXT,
	member_id INT NOT NULL REFERENCES members(member_id) ON DELETE CASCADE,
	session_id INT NOT NULL REFERENCES sessions(session_id) ON DELETE CASCADE
);

--Phase2-8--
ALTER TABLE members
	ADD COLUMN loyalty_points INT NOT NULL DEFAULT 0;

--Phase2-9--
ALTER TABLE members
	ALTER COLUMN phone TYPE VARCHAR(20);

--Phase2-10--
-- Note for Grader: The TRUNCATE command is executed here as a learning exercise; 
-- bookings data will be re-inserted in Phase 3 (DML).
TRUNCATE TABLE bookings
	RESTART IDENTITY CASCADE;


-- Phase 3: Insert Data (DML)

--Phase3-1--
INSERT INTO categories (category_name) VALUES
					('Strength Training'),
					('Cardio & Endurance'),
					('Mind & Body'),
					('Group Fitness'),
					('Aquatics');

--Phase3-2--
INSERT INTO classes (title, category_id) VALUES
					('Power Weightlifting', 1),
					('Bodybuilding Basics', 1),
					('HIIT Cardio', 2),
					('Spinning Express', 2),
					('Vinyasa Yoga', 3),
					('Mat Pilates', 3),
					('Zumba Dance', 4),
					('CrossFit Challenge', 4),
					('Core Blast', 1),
					('Stretching & Mobility', 3);

--Phase3-3--
INSERT INTO trainers (full_name, email, experience_years, mentor_id) VALUES
					('Ahmad Al-Saeed', 'ahmad.saeed@fitzone.com', 8, NULL),
					('Mona Mansour', 'mona.mansour@fitzone.com', 6, NULL),
					('Sami Haddad', 'sami.haddad@fitzone.com', 3, 1),
					('Rania Al-Kour', 'rania.kour@fitzone.com', 2, 2),
					('Omar Farooq', 'omar.farooq@fitzone.com', 1, 1),
					('Lina Kassem', 'lina.kassem@fitzone.com', 4, 2);

--Phase3-4--
INSERT INTO members (full_name, email, phone, street, city, country, status, join_date, loyalty_points) VALUES
					('Mohammad Al-Najjar', 'mohammad.alnajjar@gmail.com', '0797169202', 'King Abdullah St', 'Amman', 'Jordan', 'active', '2024-01-15', 120), -- Me Hhhhhh..
					('Sarah Ali', 'sarah.ali@yahoo.com', '0782223344', 'Mecca St', 'Amman', 'Jordan', 'active', '2024-02-10', 80),
					('Khaled Omar', 'khaled.o@gmail.com', '0773334455', 'Palestine St', 'Irbid', 'Jordan', 'active', '2024-03-01', 50),
					('Reem Nabil', 'reem.n@hotmail.com', '0794445566', '30th St', 'Irbid', 'Jordan', 'inactive', '2023-11-20', 0),
					('Youssef Salem', 'youssef.s@gmail.com', '0785556677', 'Rainbow St', 'Amman', 'Jordan', 'active', '2024-04-05', 200),
					('Nour Al-Huda', 'nour.huda@outlook.com', '0776667788', 'University St', 'Zarqa', 'Jordan', 'active', '2024-05-12', 30),
					('Hamza Kahlil', 'hamza.k@gmail.com', '0797778899', 'Baghdad St', 'Zarqa', 'Jordan', 'suspended', '2023-08-19', 0),
					('Dina Shaheen', 'dina.s@gmail.com', '0788889900', 'Medina St', 'Amman', 'Jordan', 'active', '2024-06-01', 150),
					('Fadi Bitar', 'fadi.bitar@gmail.com', '0779990011', 'Yarmouk St', 'Irbid', 'Jordan', 'active', '2024-06-20', 10),
					('Laila Hassan', 'laila.h@gmail.com', '0790001122', 'Wasfi Al-Tal St', 'Amman', 'Jordan', 'active', '2024-07-01', 0);

--Phase3-5--
INSERT INTO sessions (session_date, start_time, end_time, room, trainer_id, class_id) VALUES
					('2024-08-01', '08:00:00', '09:00:00', 'Studio A', 1, 1),
					('2024-08-01', '09:30:00', '10:30:00', 'Studio B', 2, 3),
					('2024-08-01', '11:00:00', '12:00:00', 'Studio C', 3, 5),
					('2024-08-02', '08:00:00', '09:00:00', 'Studio A', 4, 7),
					('2024-08-02', '10:00:00', '11:00:00', 'Main Gym', 1, 2),
					('2024-08-02', '16:00:00', '17:00:00', 'Studio B', 5, 4),
					('2024-08-03', '09:00:00', '10:00:00', 'Studio C', 2, 6),
					('2024-08-03', '17:00:00', '18:00:00', 'Main Gym', 3, 8),
					('2024-08-04', '08:00:00', '09:00:00', 'Studio A', 1, 9),
					('2024-08-04', '10:00:00', '11:00:00', 'Studio C', 4, 10),
					('2024-08-05', '08:00:00', '09:00:00', 'Studio B', 2, 3),
					('2024-08-05', '18:00:00', '19:00:00', 'Main Gym', 5, 1),
					('2024-08-06', '09:00:00', '10:00:00', 'Studio A', 3, 5),
					('2024-08-06', '11:00:00', '12:00:00', 'Studio C', 1, 2),
					('2024-08-07', '15:00:00', '16:00:00', 'Studio B', 4, 7),
					('2024-08-07', '17:00:00', '18:00:00', 'Main Gym', 2, 8),
					('2024-08-08', '08:00:00', '09:00:00', 'Studio A', 5, 4),
					('2024-08-08', '10:00:00', '11:00:00', 'Studio C', 3, 6),
					('2024-08-09', '09:00:00', '10:00:00', 'Studio B', 1, 9),
					('2024-08-09', '11:00:00', '12:00:00', 'Studio A', 2, 10);

--Phase3-6--
INSERT INTO bookings (booking_date, rating, comment, member_id, session_id) VALUES
					('2024-07-25', 5, 'Great energy and excellent trainer!', 1, 1),
					('2024-07-25', 4, 'Very intense workout.', 2, 1),
					('2024-07-26', 5, 'Loved the yoga flow.', 3, 3),
					('2024-07-26', 3, 'Room was a bit crowded.', 4, 2),
					('2024-07-27', 5, 'Amazing HIIT session!', 5, 2),
					('2024-07-27', 2, 'Session started late.', 6, 4),
					('2024-07-28', 4, 'Good form instruction.', 7, 5),
					('2024-07-28', 5, 'Pilates was very relaxing.', 8, 7),
					('2024-07-29', 4, 'Solid CrossFit workout.', 9, 8),
					('2024-07-29', 5, 'Best trainer ever!', 1, 9),
					('2024-07-30', 3, 'Average experience.', 2, 10),
					('2024-07-30', 5, 'Super fun Zumba class!', 3, 4),
					('2024-07-30', 4, 'Challenging session.', 5, 12),
					('2024-07-31', 5, 'Loved every minute!', 8, 13),
					('2024-07-31', 1, 'Not satisfied with equipment.', 9, 11),
					('2024-07-31', 4, 'Well structured class.', 1, 14),
					('2024-08-01', 5, 'Highly recommended!', 2, 15),
					('2024-08-01', 4, 'Great stretch routine.', 3, 20),
					('2024-08-01', 5, 'Awesome instructor.', 5, 16),
					('2024-08-01', 3, 'Decent session.', 8, 18);


-- Phase 4: Data Validation --> Personal Verification & Data Validation (Internal Check)

--Phase4-1--
SELECT * FROM categories;

--Phase4-2--
SELECT * FROM classes;

--Phase4-3--
SELECT * FROM trainers;

--Phase4-4--
SELECT * FROM members;

--Phase4-5--
SELECT * FROM sessions;

--Phase4-6--
SELECT * FROM bookings;


-- Phase 5: SQL Fundamentals & DML

--Phase5-1--
SELECT full_name AS member_full_name, email 
FROM members 
ORDER BY join_date ASC;

--Phase5-2--
SELECT DISTINCT city 
FROM members;

--Phase5-3--
SELECT * 
FROM members 
WHERE status = 'active';

--Phase5-4--
UPDATE trainers 
SET experience_years = experience_years + 1 
WHERE trainer_id = 1 
RETURNING *;

--Phase5-5--
DELETE FROM bookings 
WHERE booking_id = 20 
RETURNING *;


-- Phase 6: Security & Administration (DCL)

--Phase6-1--
CREATE USER readonly_user WITH PASSWORD 'R123456';
GRANT CONNECT ON DATABASE fitzone_db TO readonly_user;
GRANT USAGE ON SCHEMA public TO readonly_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;

--Phase6-2--
CREATE USER manager_user WITH PASSWORD 'M123456';
GRANT CONNECT ON DATABASE fitzone_db TO manager_user;
GRANT USAGE ON SCHEMA public TO manager_user;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO manager_user;

--Phase6-3--
REVOKE UPDATE ON ALL TABLES IN SCHEMA public FROM manager_user;

--Phase6-4--
/*
Database Administrator (DBA) Role & Permission Scenario:

A Database Administrator (DBA) is responsible for maintaining database security, 
data integrity, and proper access control in a company. The DBA applies the 
"Principle of Least Privilege", ensuring users only receive permissions necessary 
for their specific job roles.

For example, when an Operations Manager is hired, the DBA grants SELECT, INSERT, 
and UPDATE permissions on gym tables so the manager can handle daily operations, 
register members, and log bookings. Later, if company auditing policies change 
to restrict manual record edits, or if the employee's role changes, the DBA 
revokes UPDATE permissions to safeguard data from unauthorized modifications.
*/


-- Phase 7: Joins & Aggregations

--Phase7-1--
SELECT s.session_id, c.title AS class_name, t.full_name AS trainer_name, s.session_date, s.start_time, s.end_time, s.room
FROM sessions s INNER JOIN classes c ON s.class_id = c.class_id
INNER JOIN trainers t ON s.trainer_id = t.trainer_id;

--Phase7-2--
SELECT m.member_id, m.full_name AS member_name, COUNT(b.booking_id) AS total_bookings
FROM members m LEFT JOIN bookings b ON m.member_id = b.member_id
GROUP BY m.member_id, m.full_name
ORDER BY m.member_id;

--Phase7-3--
SELECT s.session_id, c.title AS class_name, COUNT(b.booking_id) AS booking_count
FROM bookings b RIGHT JOIN sessions s ON b.session_id = s.session_id
JOIN classes c ON s.class_id = c.class_id
GROUP BY s.session_id, c.title
ORDER BY s.session_id;

--Phase7-4--
SELECT cat.category_id, cat.category_name, c.class_id, c.title AS class_name
FROM categories cat LEFT JOIN classes c ON cat.category_id = c.category_id
ORDER BY cat.category_id;

--Phase7-5--
SELECT t.trainer_id, t.full_name AS trainer_name, m.full_name AS mentor_name
FROM trainers t LEFT JOIN trainers m ON t.mentor_id = m.trainer_id;

--Phase7-6--
SELECT m.member_id, m.full_name AS member_name, COUNT(b.booking_id) AS total_bookings
FROM members m LEFT JOIN bookings b ON m.member_id = b.member_id
GROUP BY m.member_id, m.full_name;

--Phase7-7--
SELECT t.trainer_id, t.full_name AS trainer_name, AVG(b.rating) AS avg_trainer_rating
FROM trainers t JOIN sessions s ON t.trainer_id = s.trainer_id
JOIN bookings b ON s.session_id = b.session_id
WHERE b.rating IS NOT NULL
GROUP BY t.trainer_id, t.full_name;

--Phase7-8--
SELECT c.class_id, c.title AS class_name, MAX(b.rating) AS highest_rating, MIN(b.rating) AS lowest_rating
FROM classes c JOIN sessions s ON c.class_id = s.class_id
JOIN bookings b ON s.session_id = b.session_id
WHERE b.rating IS NOT NULL
GROUP BY c.class_id, c.title;

--Phase7-9--
SELECT city, SUM(loyalty_points) AS total_loyalty_points
FROM members
GROUP BY city;

--Phase7-10--
SELECT cat.category_id, cat.category_name, COUNT(c.class_id) AS number_of_classes
FROM categories cat JOIN classes c ON cat.category_id = c.category_id
GROUP BY cat.category_id, cat.category_name HAVING COUNT(c.class_id) > 2;

--Phase7-11--
SELECT member_id, full_name, email 
FROM members 
WHERE member_id NOT IN (SELECT member_id FROM bookings WHERE member_id IS NOT NULL);

--Phase7-12--
SELECT t.trainer_id, t.full_name AS trainer_name, AVG(b.rating) AS trainer_avg_rating
FROM trainers t JOIN sessions s ON t.trainer_id = s.trainer_id
JOIN bookings b ON s.session_id = b.session_id
WHERE b.rating IS NOT NULL
GROUP BY t.trainer_id, t.full_name
HAVING AVG(b.rating) > (SELECT AVG(rating) FROM bookings WHERE rating IS NOT NULL);


-- Phase 8: Indexing

--Phase8-1--
CREATE INDEX idx_members_email ON members(email);

--Phase8-2--
CREATE INDEX idx_bookings_session_id ON bookings(session_id);

--Phase8-3--
DROP INDEX idx_members_email;