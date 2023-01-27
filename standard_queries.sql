
-- an @Offset of '0' returns values from the most recent month of data in NCDR (primary submission)

DECLARE @Offset AS INT = -1

DECLARE @PeriodStart AS DATE = (SELECT DATEADD(MONTH,@Offset,MAX([ReportingPeriodStartDate])) FROM [NHSE_IAPT_v2].[dbo].[IDS000_Header])
DECLARE @PeriodEnd AS DATE = (SELECT EOMONTH(DATEADD(MONTH,@Offset,MAX([ReportingPeriodEndDate]))) FROM [NHSE_IAPT_v2].[dbo].[IDS000_Header])

DECLARE @MonthYear AS VARCHAR(50) = (DATENAME(M, @PeriodStart) + ' ' + CAST(DATEPART(YYYY, @PeriodStart) AS VARCHAR))

SELECT  @MonthYear AS 'Month',
		COUNT(DISTINCT CASE WHEN ReferralRequestReceivedDate BETWEEN @PeriodStart AND @PeriodEnd THEN PathwayID ELSE NULL END) AS 'Count_Referrals',
		COUNT(DISTINCT CASE WHEN TherapySession_FirstDate BETWEEN @PeriodStart AND @PeriodEnd THEN PathwayID ELSE NULL END) AS 'Count_FirstTreatment',
		COUNT(DISTINCT CASE WHEN ServDischDate BETWEEN @PeriodStart AND @PeriodEnd AND CompletedTreatment_Flag = 'TRUE' THEN PathwayID ELSE NULL END) AS 'Count_FinishedCourseTreatment'

FROM    [NHSE_IAPT_v2].dbo.IDS101_Referral r
		------------------------------------
        INNER JOIN [NHSE_IAPT_v2].[dbo].[IsLatest_SubmissionID] l ON r.[UniqueSubmissionID] = l.[UniqueSubmissionID] AND r.AuditId = l.AuditId

WHERE   UsePathway_Flag = 'True' AND IsLatest = 1 
		AND h.[ReportingPeriodStartDate] BETWEEN @PeriodStart AND @PeriodEnd
