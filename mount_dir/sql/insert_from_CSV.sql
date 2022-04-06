BULK INSERT members
FROM '/mount_dir/csv/members.csv'
WITH
    (
        FIELDTERMINATOR = ',', -- 区切り文字を指定
        ROWTERMINATOR = '\n' -- 行末を示す文字を指定
    )
;
