
# College Meeting Room Reservation System

The College Meeting Room Reservation System is a web application designed to manage meeting room bookings for academic institutions. It provides functionality for users to reserve rooms, administrators to manage rooms and users, and managers to approve reservations.


## Features

User Management:
- User registration and authentication
- Password reset functionality
- Role-based access control (Normal User, Room Manager, Administrator)

Room Reservation:
- View room availability
- Create, modify, and cancel reservations
- Approval workflow for reservations

Administration:
- Manage rooms (add, edit, disable)
- Manage users (create, modify, disable)
- Generate usage reports

Reporting:
- Room utilization analytics
- Export to Excel/PDF

## Tech Stack

**Frontend:** HTML5, CSS3, TailwindCSS, JavaScript (vanilla), Font Awesome

**Backend:** Java 8+, Java Servlets, JSP, JDBC, JBCrypt


## Run Locally

Clone the Repository

```bash
  git clone https://github.com/yourusername/meeting-room-reservation.git
  cd meeting-room-reservation
```

Set Up the Database

```bash
  # Access MySQL (replace with your credentials)
  mysql -u root -p

  # In MySQL shell
  CREATE DATABASE meeting_room_db;
  USE meeting_room_db;

  # Execute the SQL scripts in this order:
  SOURCE database/01_create_tables.sql;
  SOURCE database/02_insert_sample_data.sql;  # Optional  
```

Configure the Application 

Edit the database connection settings:
```bash
  # Edit the DBUtil.java file
  nano src/com/roomreserve/util/DBUtil.java  
```
Update these values:
```java
  private static final String URL = "jdbc:mysql://localhost:3306/meeting_room_db";
  private static final String USER = "your_db_username";
  private static final String PASSWORD = "your_db_password";  
```

Edit the email connection settings:
```bash
  # Edit the EmailUtil.java file
  nano src/com/roomreserve/util/EmailUtil.java  
```
Update these values:

```java
  private static final String SMTP_USER = "your_email@gmail.com";
  private static final String SMTP_PASSWORD = "your_email_password";
  private static final String FROM_EMAIL = "your_email@gmail.com";
  private static final String SMTP_HOST = "smtp.gmail.com";
  private static final String SMTP_PORT = "465";
```

Build and Deploy

## Usage

Access the application at http://localhost:8080/meeting-room-reservation

```bash
# Default admin account:
Username: admin
Password: Admin@123 (change immediately after first login)
```


## Contributing

Fork the repository

Create a new branch (git checkout -b feature-branch)

Commit your changes (git commit -am 'Add new feature')

Push to the branch (git push origin feature-branch)

Create a new Pull Request.




## Screenshots

![Admin Dashboard](https://github.com/Akinjo-Oluwadimimu/meeting-room-reservation/blob/main/docs/images/admin%20dashboard.png)

![Manager Dashboard](https://github.com/Akinjo-Oluwadimimu/meeting-room-reservation/blob/main/docs/images/manager%20dashboard.png)

![Normal User Dashboard](https://github.com/Akinjo-Oluwadimimu/meeting-room-reservation/blob/main/docs/images/normal%20user%20dashboard.png)

![Available Rooms Listing](https://github.com/Akinjo-Oluwadimimu/meeting-room-reservation/blob/main/docs/images/available%20rooms.png)
## Demo

https://roomreserve.ddns.net/

