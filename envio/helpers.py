from datetime import datetime, timezone


def parse_quarter(quarter_str):
    """
    Parse quarter string like '2025-q2' into start and end timestamps.
    
    Args:
        quarter_str (str): Quarter in format 'YYYY-qN' (e.g., '2025-q2')
        
    Returns:
        tuple: (start_timestamp, end_timestamp) in seconds
    """
    year, quarter = quarter_str.lower().split('-q')
    year = int(year)
    quarter = int(quarter)
    
    if quarter not in [1, 2, 3, 4]:
        raise ValueError("Quarter must be 1, 2, 3, or 4")
    
    # Quarter start months: Q1=Jan, Q2=Apr, Q3=Jul, Q4=Oct
    start_month = (quarter - 1) * 3 + 1
    end_month = quarter * 3 + 1
    end_year = year if quarter < 4 else year + 1
    
    if quarter == 4:
        end_month = 1
    
    start_date = datetime(year, start_month, 1, tzinfo=timezone.utc)
    end_date = datetime(end_year, end_month, 1, tzinfo=timezone.utc)
    
    return start_date.isoformat(), end_date.isoformat()


def get_most_recent_complete_quarter():
    """
    Get the most recent complete quarter based on current date.
    
    Returns:
        str: Quarter string in format 'YYYY-qN'
    """
    now = datetime.now(timezone.utc)
    current_year = now.year
    current_month = now.month
    
    # Determine current quarter
    current_quarter = (current_month - 1) // 3 + 1
    
    # If we're in the first month of a quarter, use the previous quarter
    if current_month % 3 == 1:
        if current_quarter == 1:
            return f"{current_year - 1}-q4"
        else:
            return f"{current_year}-q{current_quarter - 1}"
    else:
        # Otherwise, use the current quarter
        return f"{current_year}-q{current_quarter}"