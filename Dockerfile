# Base image with Maven and OpenJDK
FROM maven:3.9.6-eclipse-temurin-17

# Install Chrome and ChromeDriver
RUN apt-get update && \
    apt-get install -y wget gnupg unzip curl && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    # Use a fixed stable ChromeDriver version (replace with latest stable version matching your Chrome) \
    wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# Set display to run Chrome in headless mode
ENV DISPLAY=:99

# Create work directory
WORKDIR /app

# Copy all project files
COPY . .

# Run the tests
CMD ["mvn", "test"]
