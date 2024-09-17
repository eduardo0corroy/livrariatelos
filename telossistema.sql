Criação das Tabelas CREATE TABLE Books (
  book_id INT PRIMARY KEY,
  title VARCHAR(255),
  author VARCHAR(255),
  genre VARCHAR(100),
  published_year INT
);
CREATE TABLE Users (
  user_id INT PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255)
);
CREATE TABLE Loans (
  loan_id INT PRIMARY KEY,
  book_id INT,
  user_id INT,
  loan_date DATE,
  return_date DATE,
  FOREIGN KEY (book_id) REFERENCES Books(book_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
CREATE PROCEDURE RegisterLoan (
  @book_id INT,
  @user_id INT,
  @loan_date DATE
) AS BEGIN IF NOT EXISTS (
  SELECT *
  FROM Loans
  WHERE book_id = @book_id
    AND return_date IS NULL
) BEGIN
INSERT INTO Loans (book_id, user_id, loan_date, return_date)
VALUES (@book_id, @user_id, @loan_date, NULL);
END
ELSE BEGIN PRINT 'O livro já está emprestado e não pode ser emprestado novamente.';
END
END;
CREATE PROCEDURE RegisterReturn (@loan_id INT, @return_date DATE) AS BEGIN
UPDATE Loans
SET return_date = @return_date
WHERE loan_id = @loan_id;
END;
SELECT Books.title,
  Books.published_year,
  Users.name,
  Loans.loan_date,
  Loans.return_date
FROM Loans
  JOIN Books ON Loans.book_id = Books.book_id
  JOIN Users ON Loans.user_id = Users.user_id;
b.Livros Atualmente Emprestados
SELECT Books.title,
  Books.published_year,
  Users.name,
  Loans.loan_date
FROM Loans
  JOIN Books ON Loans.book_id = Books.book_id
  JOIN Users ON Loans.user_id = Users.user_id
WHERE Loans.return_date IS NULL;
SELECT Users.name,
  COUNT(Loans.loan_id) AS total_loans
FROM Loans
  JOIN Users ON Loans.user_id = Users.user_id
GROUP BY Users.name
HAVING COUNT(Loans.loan_id) > 3;
CREATE FUNCTION TotalLoans (@user_id INT) RETURNS INT AS BEGIN RETURN (
  SELECT COUNT(*)
  FROM Loans
  WHERE user_id = @user_id
);
END;
5.Testes de Funcionalidade a.Registrar um Empréstimo EXEC RegisterLoan @book_id = 1,
@user_id = 1,
@loan_date = '2024-09-17';
EXEC RegisterReturn @loan_id = 1,
@return_date = '2024-09-20';
SELECT *
FROM Loans
WHERE return_date IS NULL;