-- distributor_notes
-- Stores follow-up interactions logged by sales reps against a distributor:
-- interaction type/status, the next follow-up date, and free-text notes.

SELECT TOP (1000)
       [note_id]
      ,[company_name]
      ,[full_address]
      ,[phone]
      ,[website]
      ,[interaction_type]
      ,[interaction_status]
      ,[followup_date]
      ,[notes]
      ,[created_by]
      ,[created_at]
  FROM [ClientDW].[dbo].[distributor_notes];
