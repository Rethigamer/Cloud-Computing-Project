from flask import Flask, request, jsonify, render_template
import os
from azure.core.credentials import AzureKeyCredential
from azure.ai.textanalytics import TextAnalyticsClient

app = Flask(__name__)

# --- Setup for Azure AI Language ---
# Use environment variables to store your credentials
language_endpoint = os.getenv("AZURE_LANGUAGE_ENDPOINT")
language_key = os.getenv("AZURE_LANGUAGE_KEY")

# Create the client object
text_analytics_client = TextAnalyticsClient(
    endpoint=language_endpoint, 
    credential=AzureKeyCredential(language_key)
)
# --- End Setup ---

# Add a route to serve the HTML file
@app.route("/")
def index():
    return render_template("index.html")

@app.route("/api/chat", methods=["POST"])
def chat():
    user_message = request.json["message"]

    try:
        # 1. Analyze the user message sentiment
        response = text_analytics_client.analyze_sentiment(
            documents=[user_message],
            show_opinion_mining=False # Set to True for detailed analysis
        )
        
        # 2. Extract the overall document sentiment
        document_sentiment = response[0].sentiment
        
        # 3. Formulate a reply based on sentiment (This replaces the LLM call)
        if document_sentiment == "negative":
            counselor_reply = (
                f"I hear the **negative** tone in your message, and I'm sorry you're feeling that way. "
                f"It takes courage to reach out. Can you tell me more about what is causing you stress?"
            )
        elif document_sentiment == "positive":
            counselor_reply = (
                f"That sounds **positive**! It's great to hear things are going well. "
                f"What do you feel has contributed most to this success?"
            )
        else:
            # Neutral or Mixed
            counselor_reply = (
                "Thank you for sharing. I'm here to listen without judgment. "
                "How can I best support you today?"
            )

        return jsonify({"reply": counselor_reply, "sentiment": document_sentiment})

    except Exception as e:
        # Handle exceptions (e.g., if the key/endpoint is wrong)
        return jsonify({"error": f"Language Service Error: {str(e)}", "detail": "Check AZURE_LANGUAGE_KEY and AZURE_LANGUAGE_ENDPOINT"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)