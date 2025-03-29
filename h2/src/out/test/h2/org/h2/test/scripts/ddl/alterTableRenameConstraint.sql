-- Copyright 2004-2025 H2 Group. Multiple-Licensed under the MPL 2.0,
-- and the EPL 1.0 (https://h2database.com/html/license.html).
-- Initial Developer: H2 Group
--

CREATE TABLE A(A INT PRIMARY KEY);
> ok

CREATE TABLE B(B INT PRIMARY KEY, A INT CONSTRAINT C REFERENCES A(A));
> ok

ALTER TABLE A RENAME CONSTRAINT C TO C1;
> exception CONSTRAINT_NOT_FOUND_1

ALTER TABLE B RENAME CONSTRAINT C TO C1;
> ok

DROP TABLE B, A;
> ok
