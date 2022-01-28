DECLARE @PeriodStart DATE
DECLARE @PeriodEnd DATE

SET @PeriodStart = '2021-09-01'
SET @PeriodEnd = '2021-09-30'

SELECT  COUNT(DISTINCT CASE WHEN ReferralRequestReceivedDate BETWEEN @PeriodStart and @PeriodEnd THEN PathwayID ELSE NULL END) AS Count_IAPTReferrals,
		    COUNT(DISTINCT CASE WHEN TherapySession_FirstDate BETWEEN @PeriodStart and @PeriodEnd THEN PathwayID ELSE NULL END) AS Count_FirstTreatment,
		    COUNT(DISTINCT CASE WHEN ServDischDate BETWEEN @PeriodStart and @PeriodEnd AND CompletedTreatment_Flag = 'TRUE' THEN PathwayID ELSE NULL END) AS Count_EndedReferrals,
		    COUNT(DISTINCT CASE WHEN ReferralRequestReceivedDate BETWEEN @PeriodStart and @PeriodEnd AND SourceOfReferralMH = 'B1' THEN PathwayID ELSE NULL END) AS Count_SelfReferrals,
		    COUNT(DISTINCT CASE WHEN ServDischDate BETWEEN @PeriodStart and @PeriodEnd AND UsePathway_Flag = 'TRUE' THEN PathwayID ELSE NULL END) AS Count_FirstAssessmentOver90days

FROM    [NHSE_IAPT_v2].dbo.IDS101_Referral r
        INNER JOIN [NHSE_IAPT_v2].[dbo].[IsLatest_SubmissionID] l ON r.[UniqueSubmissionID] = l.[UniqueSubmissionID] AND r.AuditId = l.AuditId
        INNER JOIN [NHSE_IAPT_v2].[dbo].[IDS000_Header] h ON r.[UniqueSubmissionID] = h.[UniqueSubmissionID]

WHERE   UsePathway_Flag = 'True' AND IsLatest = 1 AND h.[ReportingPeriodStartDate] BETWEEN DATEADD(MONTH, 0, @PeriodStart) AND @PeriodStart
