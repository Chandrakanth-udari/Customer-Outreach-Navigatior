-- distributor_notes
-- Stores follow-up interactions logged by sales reps against a distributor:
-- interaction type/status, the next follow-up date, and free-text notes.

CREATE TABLE dbo.distributor_notes (

    note_id             INT IDENTITY(1,1) PRIMARY KEY,

    company_name        VARCHAR(500),

    full_address        VARCHAR(500),

    phone               VARCHAR(50),

    website             VARCHAR(500),

    interaction_type    VARCHAR(100),

    interaction_status  VARCHAR(100),

    followup_date       DATE,

    notes               VARCHAR(MAX),

    created_by          VARCHAR(255),

    created_at          DATETIME DEFAULT GETDATE()

);
