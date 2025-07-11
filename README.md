# Clean Core Index
ABAP Package containing everything you (might) need to define your own Clean Core Index.

# Content
Different CDS Views to read modifications, ATC findings, User-Exits, Reports and so on as well as some analytical CDS Views based on this.

## historical data
To store historical data, class ``zbc_cclm_cleancore_index`` can be used. 

## Usage statistic SAPScript
To build usage statistics of SAPScript and Smartforms, report zbc_cclm_upl_sapscript_aggr can be maintained as periodical job. Please note that you need to implement method ``write_usage_to_db`` of class ``zbc_cclm_upl_sapscript`` 
by your own as I don't provide the table we use for this.
