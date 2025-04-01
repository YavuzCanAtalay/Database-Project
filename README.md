# 🍽️ Database Restaurant Review Web App
Sabancı University - CS306 Database Systems Term Project  
_By Yavuz Can Atalay_

---

##  Project Overview

Welcome to my CS306 term project for Sabancı University’s Database Systems course. This project is a database-backed restaurant review system designed to simulate how users interact with restaurants: submitting reviews, planning visits, and influencing reputations through triggers and procedures.

The system is structured into **three phases**, and more than **70%** of the work is completed. The final phase will be uploaded upon completion.

---

##  Project Phases

### 🔹 Phase 1: Concept and ER Design
- Designed a **review site** database schema where users can review and explore restaurants.
- Developed an **ER diagram** with:
  - **Entities:** Users, Reviews, Restaurants (subtypes: Cafes, Patisseries, Traditional), Menu
  - **Relationships:** Write, Marked, Has, Offer
- Attributes like `AverageRating`, `Reputation`, and `Nationality` enrich user and restaurant profiles.
- SQL data samples provided for all tables.

📄 See: [`CS306 Phase 1`](https://github.com/YavuzCanAtalay/Database-Project/blob/main/CS306%20Phase%201%20Proje.pdf)

---

### 🔹 Phase 2: Triggers, Procedures & Web Demo
- Implemented **triggers** to auto-update average ratings and user reputations.
- Created **stored procedures** for computing a user’s reputation based on interactions.
- Built a basic **PHP-HTML web form** for manual data submission to simulate frontend behavior.

####  Triggers Implemented:
1. **Update Average Rating** after each new review.
2. **Flag Low-Rated Restaurants** (below rating 4).
3. **Update User Reputation** on:
   - Review submission
   - Likes or follow-ups received
   - Restaurants marked

####  Stored Procedure:
- `UpdateUserReputation(uid)` calculates reputation using:
  - Total reviews
  - Likes
  - Follow-ups
  - Marked restaurants

####  Tech Stack:
- **Frontend:** HTML + CSS
- **Backend:** PHP
- **Database:** MySQL (via phpMyAdmin)
- **Local Hosting:** XAMPP (Apache + MySQL)

📄 See: [`CS306_GROUP_72_HW2_REPORT.pdf`](https://github.com/YavuzCanAtalay/Database-Project/blob/main/CS306_GROUP_72_HW2/CS306_GROUP_72_HW2_REPORT.pdf)  

Coding:
- ![HTML VSCode](https://github.com/YavuzCanAtalay/Database-Project/blob/main/CS306_GROUP_72_HW2/build/insert_review.html)
- ![PHP VSCode](https://github.com/YavuzCanAtalay/Database-Project/blob/main/CS306_GROUP_72_HW2/build/insert_review.php)
- ![Procedure MySQL](https://github.com/YavuzCanAtalay/Database-Project/tree/main/CS306_GROUP_72_HW2/scripts/stored_procedures)
- ![Triggers MySQL](https://github.com/YavuzCanAtalay/Database-Project/tree/main/CS306_GROUP_72_HW2/scripts/triggers)
- ![All Code](https://github.com/YavuzCanAtalay/Database-Project/blob/main/CS306_GROUP_72_HW2/scripts/cs306%20Code.sql)

---

### 🔹 Phase 3: Finalization (Coming Soon)
- Will integrate final UI improvements and possibly login/registration simulation.
- Further refine restaurant types and menu-item filtering.
- Additional constraints and UI validations may be added.

---

##  How to Use the Web App (Dev Mode)

> All data must currently be entered manually due to simulation mode.

1. Launch XAMPP and start Apache + MySQL.
2. Import the SQL schema and triggers via phpMyAdmin (`cs306` database).
3. Open `insert_review.html` in a browser.
4. Fill in the fields (UserID, RestaurantID, ReviewID, Rating, etc.)
5. Submit to trigger all backend logic via `insert_review.php`.

 Your review will:
- Be inserted into `has_view_reviews`
- Trigger rating update and possible restaurant flag
- Trigger user reputation update

---

##  Files Included

- `insert_review.html` — Review submission form
- `insert_review.php` — Backend PHP handling insert logic
- `CS306 Phase 1 Proje.pdf` — Initial schema, entities, sample data
- `CS306_GROUP_72_HW2_REPORT.pdf` — Phase 2 report with triggers & procedures
- `ReadMe.docx` — Usage and backend explanation
- `input_form.png`, `insertion_confirmation.png`, `has_view_reviews_data_view.png` — UI previews

---

##  Final Notes

This project is part of an academic assignment and still evolving. Also I have to add: Since aim of project is to enlighten me on database management, I'd like to inform you that I'm aware other concepts used such as web design and back end development is lacking. 

Third phase is coming soon!

---


