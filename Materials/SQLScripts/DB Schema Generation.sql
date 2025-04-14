select Case When Rank()over(partition by A.name order by B.column_id)=1 then 'WL' else '' end as SchemaName, 

      Case When Rank()over(partition by A.name order by B.column_id)=1 then a.name 

             Else '' end as TableName,

             B.name,c.name,

      Case When c.name like 'n%char' then 

                  case when B.max_length>0 then cast(B.max_length/2 AS nvarchar) else 'MAX' end

             When c.name like '%char' then 

                  case when B.max_length>0 then cast(B.max_length AS nvarchar) else 'MAX' end

             Else '' end as ColumnLength

From sys.tables A

inner join sys.columns B on A.object_id =b.object_id 

inner join sys.types C on B.user_type_id =C.user_type_id 

 where A.schema_id =6 and left(a.name,3)<>'HST'

 order by A.name,B.column_id

