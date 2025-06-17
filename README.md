# Spotify ETL Project

This project extracts, transforms, and loads (ETL) Spotify playlist data using Python, Spotipy, Pandas, and AWS S3.

## Project Structure

- [`ingestion.py`](ingestion.py): Extracts playlist data from Spotify and uploads raw JSON to S3.
- [`transforamtion.py`](transforamtion.py): Transforms raw data into structured CSVs (albums, artists, songs) and uploads them to S3.

## Prerequisites

- Python 3.x
- AWS credentials with S3 access
- Spotify API credentials (`client_id`, `client_secret`)
- Required Python packages: `spotipy`, `boto3`, `pandas`

## Setup

1. **Install dependencies:**
   ```sh
   pip install spotipy boto3 pandas
   ```

2. **Set environment variables:**
   - `client_id` and `client_secret` for Spotify API.

3. **Configure AWS credentials:**
   - Use AWS CLI or environment variables.

## Usage

### 1. Ingest Spotify Data

Run [`ingestion.py`](ingestion.py) to fetch playlist tracks and upload raw JSON to S3:

```sh
python ingestion.py
```

### 2. Transform Data

Run [`transforamtion.py`](transforamtion.py) to process raw data and upload transformed CSVs to S3:

```sh
python transforamtion.py
```

## Lambda Deployment

Both scripts are designed to be used as AWS Lambda functions. Set up Lambda with the appropriate handler (`lambda_handler`) and configure environment variables and IAM permissions for S3 and Spotify API access.

## Output

- Raw Spotify playlist data is stored in S3 under `raw_data/to_processed/`.
- Transformed CSVs are stored in S3 under:
  - `transformed_data/songs_data/`
  - `transformed_data/album_data/`
  - `transformed_data/artist_data/`

## License

MIT License

---

**Note:** Update S3 bucket names and playlist links as needed.