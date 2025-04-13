import numpy as np
import pandas as pd
import collections  
import azure.storage.blob as azureblob
import datetime
import warnings
import concurrent.futures
import multiprocessing

warnings.filterwarnings('ignore', category=FutureWarning)
warnings.filterwarnings('ignore', category=UserWarning)
warnings.filterwarnings("ignore", category=pd.errors.DtypeWarning)

def download_blob(connection_string, container_name, blob_name, local_file_path):
    """
    Downloads a blob from Azure Blob Storage to a local file.

    Args:
        connection_string: The connection string to your Azure Storage account.
        container_name: The name of the container where the blob is located.
        blob_name: The name of the blob to download.
        local_file_path: The local path where the file will be saved.
    """

    try:
        # Create a BlobServiceClient instance
        blob_service_client = azureblob.BlobServiceClient.from_connection_string(connection_string)

        # Get a reference to the container
        container_client = blob_service_client.get_container_client(container_name)

        # Download the blob to a local file
        with open(local_file_path, "wb") as local_file:
            blob_client = container_client.get_blob_client(blob_name)
            blob_data = blob_client.download_blob()
            blob_data.readinto(local_file)

        print(f"Blob '{blob_name}' downloaded successfully to '{local_file_path}'.")
    except Exception as ex:
        print(f"Error downloading blob: {ex}")

def insert_string_into_list(string, list_to_insert, index=None):
  """Inserts a string into a list at a specified index.

  Args:
    string: The string to insert.
    list_to_insert: The list to insert the string into.
    index: The optional index at which to insert the string. If not specified,
      the string will be inserted at the end of the list.

  Returns:
    The modified list with the inserted string.
  """

  if index is None:
    list_to_insert.append(string)
  else:
    list_to_insert.insert(index, string)

  return list_to_insert

def process_chunk(chunk, dimensions):
    # Extract relevant columns as a NumPy array
    data = chunk[dimensions].values
    # Create a unique identifier for each combination
    combinations = np.apply_along_axis(lambda x: hash(tuple(x)), 1, data)
    readable_combinations = {hash(tuple(data[i])): tuple(data[i]) for i in range(data.shape[0])}
    counts = collections.Counter()
    for combination in combinations:
        readable_combination = readable_combinations[combination]
        counts[readable_combination] += 1
    return counts

def dynamic_row_counter(dataset, dimension_types, batch_size=100000):
    """
    Calculates row counts for all combinations of specified dimensions in a very large dataset using batch operations.

    Args:
        dataset: The input dataset (preferably a pandas DataFrame).
        dimensions: A list of column names to use as dimensions.
        batch_size: The number of rows to process at a time (default: 100000).

    Returns:
        A dictionary containing row counts for each combination.
    """

    row_counts = collections.Counter()
    readable_counts = {}  # New dictionary to map readable combinations to their counts
    dimensions = []
    dimensionset = np.array(list(dimension_types.keys()))
    chunk_count = 0
    with concurrent.futures.ProcessPoolExecutor() as executor:
        futures = []
        for dimensionsValue in dimensionset:
            print(dimensionsValue)
            # allow the dimensions to be looped to create top level aggregations
            dimensions = insert_string_into_list(dimensionsValue, dimensions)
            for chunk in pd.read_csv(dataset, chunksize=batch_size):
                futures.append(executor.submit(process_chunk, chunk, dimensions))
        
        for future in concurrent.futures.as_completed(futures):
            chunk_counts = future.result()
            readable_counts.update(chunk_counts)
    
    # Convert readable_counts to a DataFrame
    df = pd.DataFrame.from_records(
        list(readable_counts.items()), 
        columns=['Combination', 'Count']
    )

    # Split the 'Combination' tuples into separate columns
    df = df['Combination'].apply(pd.Series)
    df['Count'] = readable_counts.values()
    df.columns = dimensions + ['Count'] 
    column_types = dimension_types
    # Convert data types
    for column, dtype in column_types.items():
        if column in df.columns:
            if dtype == 'str':
                df[column] = df[column].astype('str')
            elif dtype == 'int64':
                df[column] = pd.to_numeric(df[column], errors='coerce').astype('Int64')  # Use 'Int64' to allow NaN values
            # Add more type conversions here if needed
    df = df.groupby(dimensions, dropna=False).sum().reset_index()  # Group by all columns except 'Count'
    #df.to_csv('output_postgrouped.csv', index=False)
    print(f"Total number of chunks processed: {chunk_count}") 
    return df  # Return both row_counts and readable_counts

def main():
    print(datetime.datetime.now())
    # Example usage
    connection_string = "DefaultEndpointsProtocol=https;AccountName=adlsxyentadevuks92;EndpointSuffix=core.windows.net;SharedAccessSignature=sp=r&st=2024-10-16T12:02:55Z&se=2024-10-16T20:02:55Z&spr=https&sv=2022-11-02&sr=b&sig=LZ3s%2F2iirNQBU2i2ZJ%2BxptBDUdToafCa2B7BdB7wuGw%3D"
    container_name = "agrpremltd"
    blob_name = "Dev.Aggr_Premium_LTD.csv"
    local_file_path = "downloaded_file.txt"

    # download_blob(connection_string, container_name, blob_name, local_file_path)

    # Example usage
    data_file = "downloaded_file_12.6M.csv"
    dimensions = ['Entity','Trifocus','CCYSettlement','Scenario','YOA']
    dimension_types = {
        'Entity': 'str',
        'Trifocus': 'str',
        'CCYSettlement': 'str',
        'Scenario': 'str',
        'YOA': 'str'
    }
    result = dynamic_row_counter(data_file, dimension_types)
    print(result.count())

    print(datetime.datetime.now())

if __name__ == '__main__':
    multiprocessing.freeze_support()
    main()
