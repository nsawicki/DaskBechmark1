import dask
from dask.distributed import Client
from PIL import Image
import numpy as np
import dask.bag as db
import s3fs

# Function to read and get max pixel value
@dask.delayed
def mean_pixel_from_s3(path):
    try:
        with fs.open(path,"rb") as f:
            print('Reading ' + str(path))
            with Image.open(f) as img:
                arr = np.array(img)
                return arr.mean()
    except Exception as e:
        print(f"Failed {path}: {e}")
        return None

if __name__ == '__main__':

    # ENTER HEAD NODE PRIVATE IP HERE
    client = Client("tcp://:8786")

    # Establish s3 fs
    fs = s3fs.S3FileSystem()

    # list of image paths in S3
    image_paths = [
    ]

    ##############################################
    # Bag evaluation
    ##############################################

    # Create a Dask bag from the list
    #bag = db.from_sequence(image_paths, npartitions=len(image_paths))

    # Map the function over all images
    #mean_values = bag.map(mean_pixel_from_s3)

    # Compute results in parallel
    #results = mean_values.compute()

    #print(results)  # list of mean pixel values for each image

    #############################################
    # Delayed Evaluation
    #############################################

    # Wrap each image task with dask.delayed
    tasks = [mean_pixel_from_s3(path) for path in image_paths]

    # Compute results in parallel across workers
    results = dask.compute(*tasks)  # returns a tuple
    print(results)
