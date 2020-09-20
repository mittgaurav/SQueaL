DROP TABLE org_assets;

CREATE TABLE IF NOT EXISTS org_assets
(org_id   INT, asset_id INT);

INSERT INTO org_assets VALUES
                       (1, 1), 
                       (1, 11), 
                       (2, 2), 
                       (3, 3), 
                       (3, 13), 
                       (4, 4), 
                       (4, 14), 
                       (4, 24), 
                       (5, 5), 
                       (5, 15);

DROP TABLE political_pages;

CREATE TABLE IF NOT EXISTS political_pages
(page_id    INT PRIMARY KEY, confidence INT);

INSERT INTO political_pages VALUES
                            (1, 1), 
                            (2, 1), 
                            (4, 2), 
                            (14, 2), 
                            (15, 1);

SELECT org_id, count(asset_id), sum(CASE WHEN page_id IS NOT NULL THEN 1 ELSE 0 END) 
  FROM org_assets
       LEFT JOIN political_pages ON asset_id = page_id
 GROUP BY org_id;
