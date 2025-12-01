-- Удаление существующих таблиц
DROP TABLE IF EXISTS completed_works;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS work_schedules;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS masters;

-- Создание таблиц

CREATE TABLE masters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    hire_date DATE NOT NULL,
    dismissal_date DATE,
    salary_percent DECIMAL(5,2) NOT NULL CHECK(salary_percent > 0 AND salary_percent <= 100),
    specialization TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK(duration_minutes > 0),
    price DECIMAL(10,2) NOT NULL CHECK(price >= 0),
    category TEXT NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE clients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT,
    car_model TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE work_schedules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    master_id INTEGER NOT NULL,
    work_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE CASCADE,
    UNIQUE(master_id, work_date)
);


CREATE TABLE appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL,
    master_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status TEXT NOT NULL CHECK(status IN ('scheduled', 'completed', 'cancelled')),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (master_id) REFERENCES masters(id),
    FOREIGN KEY (service_id) REFERENCES services(id)
);


CREATE TABLE completed_works (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER NOT NULL UNIQUE,
    actual_duration_minutes INTEGER NOT NULL CHECK(actual_duration_minutes > 0),
    actual_price DECIMAL(10,2) NOT NULL CHECK(actual_price >= 0),
    completion_date DATE NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id)
);


-- Вставка данных в таблицу masters
INSERT INTO masters (id, name, phone, hire_date, dismissal_date, salary_percent, specialization) VALUES (1, 'Иван Петров', '+79161234567', '2022-01-15', NULL, 30, 'Двигатель, Трансмиссия');
INSERT INTO masters (id, name, phone, hire_date, dismissal_date, salary_percent, specialization) VALUES (2, 'Сергей Иванов', '+79161234568', '2022-03-10', '2023-06-20', 25, 'Кузовной ремонт');
INSERT INTO masters (id, name, phone, hire_date, dismissal_date, salary_percent, specialization) VALUES (3, 'Анна Сидорова', '+79161234569', '2022-05-20', NULL, 28, 'Электрика, Диагностика');
INSERT INTO masters (id, name, phone, hire_date, dismissal_date, salary_percent, specialization) VALUES (4, 'Дмитрий Козлов', '+79161234570', '2023-01-10', NULL, 32, 'Ходовая часть, Тормоза');
INSERT INTO masters (id, name, phone, hire_date, dismissal_date, salary_percent, specialization) VALUES (5, 'Ольга Николаева', '+79161234571', '2021-11-05', '2023-08-15', 27, 'Кондиционеры');

-- Вставка данных в таблицу services
INSERT INTO services (id, name, duration_minutes, price, category) VALUES (1, 'Замена масла двигателя', 60, 2500.0, 'Техобслуживание');
INSERT INTO services (id, name, duration_minutes, price, category) VALUES (2, 'Замена тормозных колодок', 120, 4000.0, 'Тормозная система');
INSERT INTO services (id, name, duration_minutes, price, category) VALUES (3, 'Диагностика двигателя', 90, 2000.0, 'Диагностика');
INSERT INTO services (id, name, duration_minutes, price, category) VALUES (4, 'Ремонт коробки передач', 240, 15000.0, 'Трансмиссия');
INSERT INTO services (id, name, duration_minutes, price, category) VALUES (5, 'Замена аккумулятора', 45, 3500.0, 'Электрика');
INSERT INTO services (id, name, duration_minutes, price, category) VALUES (6, 'Шиномонтаж', 60, 2000.0, 'Колеса');
INSERT INTO services (id, name, duration_minutes, price, category) VALUES (7, 'Развал-схождение', 90, 3000.0, 'Ходовая часть');
INSERT INTO services (id, name, duration_minutes, price, category) VALUES (8, 'Покраска бампера', 180, 8000.0, 'Кузовной ремонт');
INSERT INTO services (id, name, duration_minutes, price, category) VALUES (9, 'Заправка кондиционера', 60, 3500.0, 'Кондиционеры');
INSERT INTO services (id, name, duration_minutes, price, category) VALUES (10, 'Компьютерная диагностика', 45, 1500.0, 'Диагностика');

-- Вставка данных в таблицу clients
INSERT INTO clients (id, name, phone, email, car_model) VALUES (1, 'Алексей Волков', '+79161234572', 'volkov@mail.ru', 'Toyota Camry');
INSERT INTO clients (id, name, phone, email, car_model) VALUES (2, 'Мария Смирнова', '+79161234573', 'smirnova@gmail.com', 'Honda Civic');
INSERT INTO clients (id, name, phone, email, car_model) VALUES (3, 'Павел Орлов', '+79161234574', 'orlov@yandex.ru', 'BMW X5');
INSERT INTO clients (id, name, phone, email, car_model) VALUES (4, 'Екатерина Белова', '+79161234575', 'belova@mail.ru', 'Lada Vesta');
INSERT INTO clients (id, name, phone, email, car_model) VALUES (5, 'Николай Григорьев', '+79161234576', 'grigoryev@gmail.com', 'Kia Rio');

-- Вставка данных в таблицу work_schedules
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (1, 1, '2024-01-03', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (2, 1, '2024-01-06', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (3, 1, '2024-01-09', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (4, 1, '2024-01-12', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (5, 1, '2024-01-15', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (6, 1, '2024-01-18', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (7, 1, '2024-01-21', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (8, 1, '2024-01-24', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (9, 1, '2024-01-27', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (10, 1, '2024-01-30', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (11, 1, '2024-02-02', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (12, 1, '2024-02-05', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (13, 1, '2024-02-08', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (14, 1, '2024-02-11', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (15, 1, '2024-02-14', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (16, 1, '2024-02-17', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (17, 1, '2024-02-20', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (18, 1, '2024-02-23', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (19, 1, '2024-02-26', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (20, 1, '2024-02-29', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (21, 1, '2024-03-03', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (22, 1, '2024-03-06', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (23, 1, '2024-03-09', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (24, 1, '2024-03-12', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (25, 1, '2024-03-15', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (26, 1, '2024-03-18', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (27, 1, '2024-03-21', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (28, 1, '2024-03-24', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (29, 1, '2024-03-27', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (30, 1, '2024-03-30', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (31, 3, '2024-01-01', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (32, 3, '2024-01-04', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (33, 3, '2024-01-07', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (34, 3, '2024-01-10', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (35, 3, '2024-01-13', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (36, 3, '2024-01-16', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (37, 3, '2024-01-19', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (38, 3, '2024-01-22', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (39, 3, '2024-01-25', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (40, 3, '2024-01-28', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (41, 3, '2024-01-31', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (42, 3, '2024-02-03', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (43, 3, '2024-02-06', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (44, 3, '2024-02-09', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (45, 3, '2024-02-12', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (46, 3, '2024-02-15', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (47, 3, '2024-02-18', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (48, 3, '2024-02-21', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (49, 3, '2024-02-24', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (50, 3, '2024-02-27', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (51, 3, '2024-03-01', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (52, 3, '2024-03-04', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (53, 3, '2024-03-07', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (54, 3, '2024-03-10', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (55, 3, '2024-03-13', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (56, 3, '2024-03-16', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (57, 3, '2024-03-19', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (58, 3, '2024-03-22', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (59, 3, '2024-03-25', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (60, 3, '2024-03-28', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (61, 4, '2024-01-03', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (62, 4, '2024-01-06', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (63, 4, '2024-01-09', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (64, 4, '2024-01-12', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (65, 4, '2024-01-15', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (66, 4, '2024-01-18', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (67, 4, '2024-01-21', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (68, 4, '2024-01-24', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (69, 4, '2024-01-27', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (70, 4, '2024-01-30', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (71, 4, '2024-02-02', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (72, 4, '2024-02-05', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (73, 4, '2024-02-08', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (74, 4, '2024-02-11', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (75, 4, '2024-02-14', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (76, 4, '2024-02-17', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (77, 4, '2024-02-20', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (78, 4, '2024-02-23', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (79, 4, '2024-02-26', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (80, 4, '2024-02-29', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (81, 4, '2024-03-03', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (82, 4, '2024-03-06', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (83, 4, '2024-03-09', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (84, 4, '2024-03-12', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (85, 4, '2024-03-15', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (86, 4, '2024-03-18', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (87, 4, '2024-03-21', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (88, 4, '2024-03-24', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (89, 4, '2024-03-27', '09:00', '18:00');
INSERT INTO work_schedules (id, master_id, work_date, start_time, end_time) VALUES (90, 4, '2024-03-30', '09:00', '18:00');

-- Вставка данных в таблицу appointments
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (1, 4, 4, 4, '2024-02-29', '10:00', 'completed', 'Запись #1');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (2, 3, 1, 9, '2024-03-12', '10:00', 'scheduled', 'Запись #2');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (3, 2, 3, 6, '2024-03-04', '10:00', 'cancelled', 'Запись #3');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (4, 3, 4, 6, '2024-01-30', '10:00', 'cancelled', 'Запись #4');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (5, 2, 4, 2, '2024-01-30', '10:00', 'completed', 'Запись #5');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (6, 2, 4, 1, '2024-02-14', '10:00', 'cancelled', 'Запись #6');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (7, 4, 3, 5, '2024-01-25', '10:00', 'completed', 'Запись #7');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (8, 4, 3, 9, '2024-02-27', '10:00', 'cancelled', 'Запись #8');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (9, 5, 1, 3, '2024-03-27', '10:00', 'scheduled', 'Запись #9');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (10, 1, 4, 4, '2024-02-14', '10:00', 'scheduled', 'Запись #10');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (11, 3, 3, 8, '2024-02-15', '10:00', 'cancelled', 'Запись #11');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (12, 4, 1, 5, '2024-02-23', '10:00', 'scheduled', 'Запись #12');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (13, 1, 4, 10, '2024-01-21', '10:00', 'cancelled', 'Запись #13');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (14, 4, 4, 1, '2024-02-23', '10:00', 'completed', 'Запись #14');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (15, 1, 1, 10, '2024-03-15', '10:00', 'completed', 'Запись #15');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (16, 4, 3, 5, '2024-01-25', '10:00', 'scheduled', 'Запись #16');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (17, 5, 3, 10, '2024-01-25', '10:00', 'completed', 'Запись #17');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (18, 3, 3, 7, '2024-03-19', '10:00', 'cancelled', 'Запись #18');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (19, 2, 1, 1, '2024-03-09', '10:00', 'cancelled', 'Запись #19');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (20, 1, 4, 9, '2024-01-12', '10:00', 'scheduled', 'Запись #20');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (21, 1, 3, 6, '2024-01-31', '10:00', 'scheduled', 'Запись #21');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (22, 5, 4, 8, '2024-02-26', '10:00', 'scheduled', 'Запись #22');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (23, 5, 3, 10, '2024-01-19', '10:00', 'cancelled', 'Запись #23');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (24, 3, 1, 10, '2024-03-27', '10:00', 'completed', 'Запись #24');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (25, 3, 3, 7, '2024-01-07', '10:00', 'cancelled', 'Запись #25');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (26, 1, 1, 10, '2024-03-21', '10:00', 'cancelled', 'Запись #26');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (27, 5, 3, 6, '2024-03-19', '10:00', 'completed', 'Запись #27');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (28, 5, 4, 3, '2024-03-27', '10:00', 'scheduled', 'Запись #28');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (29, 2, 1, 6, '2024-02-26', '10:00', 'cancelled', 'Запись #29');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (30, 1, 4, 8, '2024-03-18', '10:00', 'scheduled', 'Запись #30');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (31, 1, 1, 2, '2024-02-14', '10:00', 'scheduled', 'Запись #31');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (32, 5, 3, 9, '2024-02-12', '10:00', 'completed', 'Запись #32');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (33, 2, 4, 10, '2024-02-23', '10:00', 'cancelled', 'Запись #33');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (34, 1, 3, 2, '2024-02-03', '10:00', 'scheduled', 'Запись #34');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (35, 2, 3, 8, '2024-01-19', '10:00', 'cancelled', 'Запись #35');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (36, 1, 4, 2, '2024-01-06', '10:00', 'completed', 'Запись #36');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (37, 3, 4, 2, '2024-03-09', '10:00', 'cancelled', 'Запись #37');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (38, 3, 3, 10, '2024-01-16', '10:00', 'cancelled', 'Запись #38');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (39, 5, 4, 3, '2024-02-26', '10:00', 'cancelled', 'Запись #39');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (40, 3, 1, 10, '2024-03-18', '10:00', 'completed', 'Запись #40');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (41, 3, 1, 4, '2024-03-24', '10:00', 'cancelled', 'Запись #41');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (42, 4, 1, 1, '2024-01-03', '10:00', 'cancelled', 'Запись #42');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (43, 2, 3, 2, '2024-01-31', '10:00', 'scheduled', 'Запись #43');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (44, 4, 4, 9, '2024-03-24', '10:00', 'completed', 'Запись #44');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (45, 1, 3, 7, '2024-03-25', '10:00', 'cancelled', 'Запись #45');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (46, 1, 3, 8, '2024-03-13', '10:00', 'scheduled', 'Запись #46');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (47, 2, 3, 3, '2024-01-28', '10:00', 'cancelled', 'Запись #47');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (48, 1, 3, 9, '2024-03-10', '10:00', 'cancelled', 'Запись #48');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (49, 4, 4, 3, '2024-01-03', '10:00', 'cancelled', 'Запись #49');
INSERT INTO appointments (id, client_id, master_id, service_id, appointment_date, appointment_time, status, notes) VALUES (50, 1, 1, 1, '2024-02-26', '10:00', 'scheduled', 'Запись #50');

-- Вставка данных в таблицу completed_works
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (1, 1, 180, 7002.2054015175145, '2024-02-29', 'Работа выполнена качественно');
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (2, 5, 171, 4994.600183524931, '2024-01-30', 'Работа выполнена качественно');
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (3, 7, 89, 19883.486418958913, '2024-01-25', 'Работа выполнена качественно');
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (4, 14, 105, 2073.6545511628947, '2024-02-23', 'Работа выполнена качественно');
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (5, 15, 81, 15125.511196290305, '2024-03-15', 'Работа выполнена качественно');
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (6, 17, 100, 11526.937816366468, '2024-01-25', 'Работа выполнена качественно');
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (7, 24, 97, 16515.442520025943, '2024-03-27', 'Работа выполнена качественно');
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (8, 27, 167, 16137.494903237699, '2024-03-19', 'Работа выполнена качественно');
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (9, 32, 166, 18377.397599977103, '2024-02-12', 'Работа выполнена качественно');
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (10, 36, 97, 8847.524107458394, '2024-01-06', 'Работа выполнена качественно');
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (11, 40, 55, 11244.293096578058, '2024-03-18', 'Работа выполнена качественно');
INSERT INTO completed_works (id, appointment_id, actual_duration_minutes, actual_price, completion_date, notes) VALUES (12, 44, 116, 19569.44691109945, '2024-03-24', 'Работа выполнена качественно');

-- Создание индексов
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_master_date ON appointments(master_id, appointment_date);
CREATE INDEX idx_completed_works_date ON completed_works(completion_date);
CREATE INDEX idx_masters_status ON masters(dismissal_date);
CREATE INDEX idx_work_schedules_master_date ON work_schedules(master_id, work_date);

-- Примеры запросов для отчетов

-- Отчет по выручке и зарплате мастеров за период
SELECT 
    m.name AS master_name,
    COUNT(cw.id) AS completed_works,
    SUM(cw.actual_price) AS total_revenue,
    SUM(cw.actual_price * m.salary_percent / 100) AS master_salary
FROM completed_works cw
JOIN appointments a ON cw.appointment_id = a.id
JOIN masters m ON a.master_id = m.id
WHERE cw.completion_date BETWEEN '2024-01-01' AND '2024-03-31'
GROUP BY m.id, m.name
ORDER BY total_revenue DESC;


-- Статистика по услугам
SELECT 
    s.category,
    s.name AS service_name,
    COUNT(a.id) AS total_appointments,
    AVG(cw.actual_price) AS avg_actual_price
FROM services s
LEFT JOIN appointments a ON s.id = a.service_id
LEFT JOIN completed_works cw ON a.id = cw.appointment_id
GROUP BY s.category, s.name
ORDER BY s.category, total_appointments DESC;
