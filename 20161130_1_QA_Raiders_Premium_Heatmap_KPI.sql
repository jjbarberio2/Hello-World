use raiders

create table #qa(
Step INT identity(1,1)
,dimEventId INT
) 

INSERT INTO #qa
select dimeventID from dimevent where dimseasonid IN(63,66) order by dimeventid

create table #output(
EventDate						DATE
, HeatmapSectionDefinitionId	INT
, EventName						varchar(max)
, SSID_section_id				varchar(max)
, Total_Available				INT
, Total_Qty						INT
, Occupancy_Percent				DECIMAL(5,3)
, VectorPath					varchar(max)
, HeatmapSectionName			varchar(max)
, DimSeasonHeaderId				INT
, DimEventHeaderId				INT
, PopupText						varchar(200)
, SectionLabelTransform			varchar(200)
, SectionColor					varchar(200)
, Stroke						varchar(200)
, FillOpacity					varchar(200)
, StrokeWidth					varchar(200)
, FillOverride					varchar(200)
, PathTransform					varchar(200)
, SectionNativeKey				varchar(200)
, SectionName					varchar(200)
, FirstName						varchar(200)
, LastName						varchar(200)
, CompanyName					varchar(200)
, SalesRep						varchar(200)
, SuitePrice					Numeric(18,2)
, SuiteCategory					varchar(200)
, RepType						varchar(200)
, SectionType					varchar(200)
, SectionClass					varchar(200)
, DetailGrouping				varchar(200)
, DetailSumCategory				varchar(200)
)

DECLARE @step INT = 1
DECLARE @dimeventID INT

WHILE @step <= (select MAX(step) FROM #qa)
BEGIN

SET @dimeventID = (select dimeventid from #qa where step = @step)
INSERT INTO #output exec [rpt].[rptCust_HeatMap_Suites2016_Occupancy] @dimeventid
set @step += 1

END

select  eventName,suitecategory, sum(suiteprice)SuiteTotal
from #output
where ISNULL(eventname,'')<>''
	  and suitecategory = 'Annual Suite Reserved'
GROUP BY eventName,suitecategory

select * FROM 
/*
DROP TABLE #qa
DROP TABLE #output
*/