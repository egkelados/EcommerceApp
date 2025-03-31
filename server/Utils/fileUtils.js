const fs = require("fs");
const path = require("path");

// extract the file name from a url
const getFileNameFromUrl = (photoUrl) => {
  try {
    const url = new URL(photoUrl);
    const fileName = path.basename(url.pathname);
    console.log("Extracted file name:", fileName);

    return fileName;
  } catch (error) {
    console.log("Invalid URL: ", error);
    return null;
  }
};

const deleteFile = (fileName) => {
  return new Promise((resolve, reject) => {
    if (!fileName) {
      return resolve();
    }

    const filePath = path.join(__dirname, "../uploads", fileName);

    fs.access(filePath, fs.constants.F_OK, (accessErr) => {
      if (accessErr) {
        console.log("File does not exist");
        return resolve(); // if the file does not exist, we consider it successfully deleted
      }

      fs.unlink(filePath, (unlinkErr) => {
        if (unlinkErr) {
          console.log("Error deleting file: ", unlinkErr);
          return reject(unlinkErr);
        }

        console.log("File deleted successfully");
        resolve();
      });
    });
  });
};

module.exports = {
  getFileNameFromUrl,
  deleteFile,
};
