INSERT INTO token (token_name) VALUES
('Mortarboard'),
('Book'),
('Certificate'),
('Gown'),
('Laptop'),
('Pen')
;
INSERT INTO location (location_id, location_type, location_name, board_position) VALUES
(1, 'corner', 'Welcome Week', 1),
(2, 'building', 'Kilburn', 2),
(3, 'building', 'IT', 3),
(4, 'hearing', 'Hearing 1', 4),
(5, 'building', 'Uni Place', 5),
(6, 'building', 'AMBS', 6),
(7, 'rag', 'RAG 1', 7),
(8, 'corner', 'Visitor', 8),
(9, 'building', 'Crawford', 9),
(10, 'building', 'Sugden',  10),
(11, 'corner', 'Ali G', 11),
(12, 'building', 'Shopping Precinct', 12),
(13, 'building', 'MECD', 13),
(14, 'rag', 'RAG 2', 14),
(15, 'building', 'Library', 15),
(16, 'building', 'Sam Alex', 16),
(17, 'hearing', 'Hearing 2', 17),
(18, 'corner', 'You''re Suspended!', 18),
(19, 'building', 'Museum', 19),
(20, 'building', 'Whitworth Hall', 20);

INSERT INTO special (special_id, location_id, name, description, special_type) VALUES
(1, 4, 'Hearing_1', 'You are found guilty of academic malpractice. Fined 30 credits.', 'hearing'),
(2, 7, 'RAG 1', 'You win a fancy dress contest. Win 75 credits.', 'rag'),
(3, 14, 'RAG 2', 'You receive a bursary and share it with your friends. All players receive 50 credits.', 'rag'),
(4, 17, 'Hearing 2', 'You are in rent arrears. Fined 100 credits.', 'hearing'),
(5, 18, 'You''re Suspended!', 'Move directly to Suspension. Do not collect 100 credits.', 'corner');

INSERT INTO player (player_id, token_id, current_location, name, credits, status) VALUES
(1, 3, 19, 'Gareth', 430, 'active'),
(2, 1, 2, 'Stewart', 360, 'active'),
(3, 2, 6, 'Emma', 470, 'active'),
(4, 6, 4, 'Nadine', 400, 'active');

INSERT INTO building (building_id, location_id, name, owner_id, tuition_fee, colour_group) VALUES
(1, 2, 'Kilburn', 4, 15, 'green'),
(2, 3, 'IT', 1, 15, 'green'),
(3, 5, 'Uni Place', 1, 25, 'orange'),
(4, 6, 'AMBS', 2, 25, 'orange'),
(5, 9, 'Crawford', 3, 30, 'blue'),
(6, 10, 'Sugden', 1, 30, 'blue'),
(7, 12, 'Shopping Precinct', NULL, 35, 'brown'),
(8, 13, 'MECD', 2, 35, 'brown'),
(9, 15, 'Library', 3, 40, 'grey'),
(10, 16, 'Sam Alex', NULL, 40, 'grey'),
(11, 19, 'Museum', 3, 50, 'black'),
(12, 20, 'Whitworth Hall', 4, 50, 'black');

INSERT INTO audit_log (audit_id, landed_location, player_id, round_number, turn_number, credit_balance, roll) VALUES
(1, 19, 1, 0, 0, 430, 0),
(2, 2, 2, 0, 0, 360, 0),
(3, 6, 3, 0, 0, 470, 0),
(4, 4, 4, 0, 0, 400, 0)
;