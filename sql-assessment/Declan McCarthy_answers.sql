create table marketing_data (
 date datetime,
 campaign_id varchar(50),
 geo varchar(50),
 cost float,
 impressions float,
 clicks float,
 conversions float
);

create table website_revenue (
 date datetime,
 campaign_id varchar(50),
 state varchar(2),
 revenue float
);

create table campaign_info (
 id int not null primary key auto_increment,
 name varchar(50),
 status varchar(50),
 last_updated_date datetime
 );
 
 select * from marketing_data /*Used MySQL workbench csv import tool to fill data*/;
 
 select * from website_revenue /*Used MySQL workbench csv import tool to fill data*/;
 
 select * from campaign_info /*Used MySQL workbench csv import tool to fill data*/;
 
 /*1. Write a query to get the sum of impressions by day.*/
 select date, sum(impressions) as "Total Impressions"
 from marketing_data
 group by date
 order by date;
 
 /*2. Write a query to get the top three revenue-generating states in order of best to worst.
 How much revenue did the third best state generate?"*/
 select state, sum(revenue) as "Total Revenue"
 from website_revenue
 group by state
 order by sum(revenue) desc
 limit 3;
 /*The third best state is OH with $37,577 (I assumed to format this answer as a comment)*/
 
 /*3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign.
 Make sure to include the campaign name in the output.*/
 select campaign.id, coalesce(market.total_cost, 0) as "total cost", coalesce(market.total_impressions, 0) as "total impressions", coalesce(market.total_clicks, 0) as "total clicks", coalesce(website.total_revenue, 0) as "total revenue"
 from campaign_info campaign
 left join (select campaign_id,
        sum(cost) as total_cost,
        sum(impressions) as total_impressions,
        sum(clicks) as total_clicks
    from marketing_data
    group by campaign_id) 
    market on campaign.id = market.campaign_id
 left join (select campaign_id,
        sum(revenue) as total_revenue
    from website_revenue
    group by campaign_id) 
    website on campaign.id = website.campaign_id;
    
 /*4. Write a query to get the number of conversions of Campaign5 by state. 
 Which state generated the most conversions for this campaign?*/
 select campaign_info.id, marketing_data.geo, campaign_info.name, sum(marketing_data.conversions)
 from campaign_info inner join marketing_data on campaign_info.id = marketing_data.campaign_id
 where campaign_info.name = "campaign5"
 group by campaign_info.id, marketing_data.geo
 order by sum(marketing_data.conversions) desc;
 /*The state with the most conversions is Georgia (I assumed to format this answer as a comment)*/
 
 /*5. In your opinion, which campaign was the most efficient, and why?*/
 select campaign.id, coalesce(market.total_cost, 0) as "total cost", coalesce(market.total_impressions, 0)/coalesce(market.total_cost, 0) as "unit cost impressions", coalesce(market.total_clicks, 0)/coalesce(market.total_cost, 0) as "unit cost clicks", coalesce(website.total_revenue, 0)/coalesce(market.total_cost, 0) as "unit cost revenue"
 from campaign_info campaign
 left join (select campaign_id,
        sum(cost) as total_cost,
        sum(impressions) as total_impressions,
        sum(clicks) as total_clicks
    from marketing_data
    group by campaign_id) 
    market on campaign.id = market.campaign_id
 left join (select campaign_id,
        sum(revenue) as total_revenue
    from website_revenue
    group by campaign_id) 
    website on campaign.id = website.campaign_id;
 /*Efficiency can be measured using different metrics, so I modified the code from problem 3 to determine
 the unit cost of every metric. I believe that Campaign5 is the most efficient because it has the most revenue
 earned per dollar spent. However if impressions, clicks or conversions were valued more, you would want
 the campaign with the highest unit cost for those metrics.*/
 
 /*6. Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.*/
 select date, sum(revenue)
 from website_revenue
 group by date
 order by sum(revenue) desc;
 