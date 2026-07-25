<div align="center">

# 🏋️‍♂️ FitZone Gym Management System

**A robust, scalable PostgreSQL database solution for managing modern fitness centers.**

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](#)
[![SQL](https://img.shields.io/badge/Language-SQL-orange?style=for-the-badge)](#)
[![Database Design](https://img.shields.io/badge/Design-ERD%20%26%20Normalization-green?style=for-the-badge)](#)

</div>

---

## 📌 Overview

**FitZone** is a comprehensive relational database system built using **PostgreSQL**. It is engineered to streamline operations for fitness centers by effectively handling member subscriptions, trainer assignments, class schedules, bookings, and complex hierarchical trainer mentorship.

---

## 📐 Entity-Relationship Diagram (ERD)

Below is the structural schema representing the database design, tables, primary keys, foreign keys, and relational cardinalities:

<div align="center">

![FitZone ERD](Schema_Diagram.png)

</div>

---

## ✨ Key Features & Technical Highlights

* **📑 Structured Architecture (DDL):** Normalized tables enforcing strict data integrity via `PRIMARY KEY`, `FOREIGN KEY`, `CHECK`, and `UNIQUE` constraints.
* **🔄 Advanced Relational Modeling:**
  * **1:N & N:M Relationships:** Seamless linking between members, packages, trainers, and classes.
  * **Self-Referential Mentorship:** Implemented a self-referencing relationship within the Trainers table to model senior-junior mentorship structures.
* **🔍 Complex SQL Queries:**
  * Multi-table `JOIN` operations for aggregated reporting.
  * Analytical queries using aggregate functions (`COUNT`, `AVG`, `SUM`) paired with `GROUP BY` and `HAVING` clauses.
  * Subqueries and conditional filtering.
* **⚡ Performance Optimization:** Applied strategic **B-Tree Indexing** on high-frequency search columns (e.g., Member Emails, Booking Dates) to enhance query execution performance.
* **🔐 Data Control & Security (DCL):** Configured Role-Based Access Control (RBAC) establishing specific privileges for `DBA_Role`, `Trainer_Role`, and `Member_Role`.

---

## 📂 Repository Structure

```text
├── fitzone_assignment.sql   # Full SQL script (DDL, DML, DCL, Queries & Indexing)
├── Schema_Diagram.png       # ERD / Database visual schema
└── README.md                # Project documentation
