# Spotify ETL Project

This project automates the extraction, transformation, and loading (ETL) of Spotify playlist data using Python, Spotify, AWS Lambda, and Amazon S3. The pipeline enables scalable, serverless data engineering and analytics on Spotify music data.

---

## Architecture

![Spotify ETL Architecture](./architecture-diagram.png)

**Pipeline Overview:**
- **Extract:**  
  - AWS Lambda (Python) fetches playlist data from the Spotify API (triggered by CloudWatch).
  - Raw data is stored in Amazon S3.
- **Transform:**  
  - S3 event triggers a second Lambda function to process and normalize the data into CSVs (songs, albums, artists).
  - Transformed data is stored in a separate S3 location.
- **Load:**  
  - AWS Glue Crawler infers schema and updates the Glue Data Catalog.
  - Amazon Athena enables SQL-based analytics on the processed data.

---

## AWS Services Creation and Configuration

To implement the ETL pipeline as described in the architecture, follow these steps to create and configure the required AWS services:

### 1. Amazon S3
- **Create a bucket:**  
  Name: `spotify-etl-prj-py`
- **Folder structure:**  
  - `raw_data/to_processed/` — for raw data after ingestion  
  - `raw_data/processed/` — for raw data after transformation  
  - `transformed_data/album_data/` — for album CSVs  
  - `transformed_data/artist_data/` — for artist CSVs  
  - `transformed_data/songs_data/` — for song CSVs

### 2. AWS Lambda
- **Ingestion Lambda Function:**  
  - **Purpose:** Extracts playlist data from the Spotify API and stores it as raw JSON in S3.
  - **Trigger:**  
    - **Amazon CloudWatch Event Rule (EventBridge):** Set up a scheduled rule (e.g., daily) to automatically invoke the ingestion Lambda.
  - **Configuration:**  
    - Environment variables: `client_id`, `client_secret` (Spotify API credentials)
    - IAM Role: Permissions to write to S3 (`raw_data/to_processed/`)
- **Transformation Lambda Function:**  
  - **Purpose:** Processes raw JSON files from S3, transforms them into structured CSVs, and uploads them to the appropriate S3 folders.
  - **Trigger:**  
    - **S3 Event Notification:** Configure the S3 bucket (`raw_data/to_processed/`) to trigger the transformation Lambda when a new file is created.
  - **Configuration:**  
    - Attach a Lambda Layer with required Python packages (`spotipy`, `pandas`)
    - IAM Role: Permissions to read from and write to the relevant S3 folders

### 3. Amazon CloudWatch
- **Create a scheduled rule** to trigger the Ingestion Lambda at your desired frequency (e.g., daily).

### 4. AWS Glue
- **Create a Glue Crawler:**  
  - Source: `transformed_data/` folders in your S3 bucket
  - Target: AWS Glue Data Catalog
  - Purpose: Infer schema for Athena queries

### 5. Amazon Athena
- **Configure Athena** to use the Glue Data Catalog as its data source.
- **Query your transformed data** using standard SQL.

---

**IAM Permissions:**  
Ensure all Lambda functions have the necessary IAM roles to access S3, CloudWatch, and Glue as needed.

**Environment Variables:**  
Store sensitive data like Spotify API credentials as Lambda environment variables, not in code.

---

This setup ensures your ETL pipeline is automated, event-driven, and ready for analytics as per the architecture diagram.
---

## S3 Bucket Structure

All data for this project is stored in a single S3 bucket:  
**Bucket name:** `spotify-etl-prj-py`

The bucket contains the following folders:

- **raw_data/**
  - **to_processed/**  
    Stores raw data files after ingestion, ready to be transformed.
  - **processed/**  
    Stores raw data files after transformation is complete.

- **transformed_data/**
  - **album_data/**  
    Contains CSV files with album information.
  - **artist_data/**  
    Contains CSV files with artist information.
  - **songs_data/**  
    Contains CSV files with song information.

This structure helps organize the ETL workflow and makes it easy to manage and locate files at each stage of the pipeline.

## Project Structure

- [`ingestion.py`](ingestion.py): Extracts playlist data from Spotify and uploads raw JSON to S3.
- [`transformation.py`](transformation.py): Transforms raw data into structured CSVs and uploads them to S3.

---

## Prerequisites

- Python 3.x
- AWS account with S3, Lambda, Glue, and Athena permissions
- Spotify API credentials (`client_id`, `client_secret`)
- Python packages: `spotipy`, `boto3`, `pandas`

---

## About the Required Python Packages

This project relies on the following key Python packages:

- **spotipy:**  
  Spotipy is a lightweight Python library for the Spotify Web API. It is used in this project to authenticate with Spotify and extract playlist, track, album, and artist data programmatically.

- **pandas:**  
  Pandas is a powerful data analysis and manipulation library for Python. In this project, it is used to transform raw Spotify data into structured tabular formats (CSV files) for further analysis and storage.

Both packages must be available to your AWS Lambda functions. If deploying on AWS Lambda, ensure these dependencies are included in a Lambda Layer and attached to your function.

## Using Lambda Layers for External Python Packages

To provide your AWS Lambda function with external Python packages (such as `spotipy` and `pandas`):

1. Download or create a ZIP file containing the required packages (e.g., `spotipy`) from the `packages` directory. For `pandas`, you can use AWS's provided public layer or include it in your ZIP.
2. Go to the AWS Lambda Console → Layers.
3. Click "Create layer" and upload your ZIP file.
4. Attach the created layer to your Lambda function.

That’s it! Your Lambda function will now have access to the required packages.

## Generating Spotify API Credentials

To access Spotify data programmatically, you need Spotify API credentials (`client_id` and `client_secret`).  
Follow these steps to generate them:

1. Go to the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard).
2. Log in with your Spotify account.
3. Click on "Create an App".
4. Enter an app name and description, then click "Create".
5. On your app page, you will find your **Client ID** and **Client Secret**.
6. Use these credentials as environment variables in your Lambda function or local environment:
   - `client_id`
   - `client_secret`

**Note:**  
Keep your credentials secure and do not share them publicly or commit them to version control.

## Setup

1. **Set environment variables:**
   - `client_id` and `client_secret` for Spotify API.

2. **Configure AWS credentials:**
   - Use AWS CLI (`aws configure`) or environment variables.

---

## Usage

### 1. Ingest Spotify Data

Run the ingestion script to fetch playlist tracks and upload raw JSON to S3:

```sh
python ingestion.py
```

### 2. Transform Data

Run the transformation script to process raw data and upload transformed CSVs to S3:

```sh
python transformation.py
```

---

## AWS Lambda Deployment

- Both scripts can be deployed as AWS Lambda functions.
- Set environment variables and IAM permissions for S3 and Spotify API access.
- Use CloudWatch Events to schedule extraction and S3 triggers for transformation.

---

## Output

- **Raw Data:**  
  - S3: `raw_data/to_processed/`
- **Transformed Data:**  
  - S3: `transformed_data/songs_data/`
  - S3: `transformed_data/album_data/`
  - S3: `transformed_data/artist_data/`

---

## Example Analysis Questions

Once your Spotify data is processed and available in Amazon Athena, you can explore insights such as:

- **Top Artists:**  
  Who are the most featured artists in the playlist(s)?

- **Popular Songs:**  
  Which songs have the highest popularity scores?

- **Album Trends:**  
  Which albums have the most tracks in the playlist(s)?

- **Release Date Analysis:**  
  What is the distribution of song release years in the playlist(s)?

- **Playlist Freshness:**  
  How many songs were added to the playlist in the last month, quarter, or year?

- **Artist Diversity:**  
  How many unique artists are represented in the playlist(s)?

- **Song Duration:**  
  What is the average, shortest, and longest song duration?

- **Popularity by Artist:**  
  Which artists have the highest average song popularity?

- **Recent Releases:**  
  Which songs in the playlist(s) were released in the last year?

- **Most Added Albums:**  
  Which albums have the most songs added to the playlist(s) recently?

You can use SQL queries in Athena to answer these questions using your `songs_data`, `album_data`, and `artist_data` tables.
