bulk insert members
from '/mount_dir/csv/members.csv'
with
    (
        fieldterminator = ',', -- 区切り文字を指定
        rowterminator = '\n' -- 行末を示す文字を指定
    )
;
