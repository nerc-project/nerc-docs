# Predictive & Generative AI (LLM & RAG) in Action

## Context and definitions

### Model Building vs. Model Tuning

Building an AI model from scratch requires gathering large datasets (corpus) and
training a model, which is resource-intensive and time-consuming. In contrast,
model tuning optimizes a pretrained model's hyperparameters to improve its
performance, making it more efficient for specific tasks.

### Model Tuning vs. Fine Tuning

Model tuning optimizes a model's hyperparameters, while fine-tuning adapts a
pretrained model for a specific task by adjusting its weights and sometimes
architecture. Fine-tuning enhances the model's performance for specialized tasks,
ike sentiment analysis or question answering, without needing to train a new model
from scratch.

| Aspect          | Model Tuning | Fine-Tuning |
|-----------------|--------------|-------------|
| **Purpose**     | Optimizes hyperparameters to improve model performance | Adapts a pre-trained model to a specific task |
| **Changes**     | Adjusts training settings (learning rate, batch size, etc.) | Modifies model weights and sometimes architecture |
| **Scope**       | Can be applied to both pre-trained and newly trained models | Focuses on pre-trained models for domain-specific tasks |
| **Example**     | Finding the best learning rate for training | Training a pre-trained BERT model on medical texts |

!!! info "Note"

    Model tuning focuses on optimizing hyperparameters, while fine-tuning adapts
    a model by modifying its weights for a specific application.

### Pre-trained models vs. Fine-tuned LLMs

Pre-trained models like Granite, Mistral, GPT-4, or LLaMA are trained on vast,
diverse datasets, enabling them to perform general-purpose language tasks. However,
they may lack domain-specific knowledge or precision in specialized contexts.

Fine-tuning involves further training a model on a smaller, task-specific dataset
to improve its performance for a particular use case. It enhances accuracy,
efficiency, and customization while reducing prompt complexity and incorporating
proprietary data.

### Foundation Model

Foundation models are a subset of pre-trained models designed to serve as a strong
base for multiple downstream tasks without requiring extensive modifications.
They are typically large-scale models trained on diverse datasets, capturing
broad knowledge that can be fine-tuned for specialized applications.

By leveraging foundation models, developers can significantly reduce the time
and resources needed for task-specific training. These models enable efficient
adaptation to various domains, making them a powerful tool for AI-driven applications.

### Quantization

Model quantization reduces computational and memory demands by converting model
parameters into lower-precision formats. This improves efficiency, making models
more suitable for resource-constrained devices, albeit with a slight loss in accuracy.

### Embeddings

Embeddings represent words or phrases as multi-dimensional vectors that capture
semantic relationships, allowing machines to better understand language. They are
created through unsupervised learning and are crucial for tasks like sentiment
analysis, machine translation, and recommendation systems.

### Vector Database

A vector database efficiently stores and manages multi-dimensional vector data,
optimized for high-dimensional operations. These databases are widely used in
machine learning, image processing, and NLP to enable fast retrieval and complex
computations on vector data.

## Predictive AI

Using historical data, predictive AI enables organizations to identify patterns
and make informed decisions about the future. By training a model with your own
data, you're essentially creating a tool that can forecast outcomes based on
patterns and insights derived from the past data it has learned from. It powers
applications such as demand forecasting, predictive maintenance, and operational
planning. Predictive AI relies on well-established data science and Machine
Learning (ML) techniques, continuously improving as it processes more data.

### Predictive AI tutorial - Credit Card Fraud Detection Application

In [this tutorial](fraud-detection-predictive-ai-app.md), we will demonstrate how
to use [NERC Red Hat OpenShift AI (RHOAI)](../index.md) to train a fraud detection
model in JupyterLab, deploy it, refine it using automated pipelines, and deploy
the "Credit Card Fraud Detection" application that use [Gradio](https://www.gradio.app/)
as the UI engine, in [NERC OpenShift](../../openshift/index.md), which connects
to the deployed model.

![Predict Credit Card Fraud App Gradio Interface](images/gradio_application_interface.png)

### Predictive AI tutorial - Object Detection Application Using YOLOv5 Model

In [this tutorial](object-detection-app-using-yolo5.md), we will explore how to
use [YOLOv5)](https://github.com/ultralytics/yolov5/), an object detection model,
to recognize specific objects in images, as well as how to deploy and utilize
the model.

![Object Detection Application Using YOLOv5 Model](images/object-detection-result.png)

## Generative AI (GenAI)

Generative AI, powered by deep learning models like transformers, can generate
new content, including text, images, and code. It is especially valuable for
applications such as chatbots, automated content creation, and creative tools.
Models like generative pretrained transformers (GPTs) have transformed natural
language processing and creative industries by producing human-like text, images,
music, and more by generating outputs that closely resemble the data on which
they were trained.

## Comparision Between Predictive AI and Generative AI

| Type of AI      | Purpose                                      | Techniques                                    | Examples                           |
|-----------------|----------------------------------------------|-----------------------------------------------|------------------------------------|
| Predictive AI   | Uses historical data to forecast future events or trends. | Regression analysis, classification, time series forecasting, machine learning models. | Predicting stock prices, customer behavior, equipment failure. |
| Generative AI   | Creates new content like text, images, and music based on input data. | Generative Adversarial Networks (GANs), Transformers. | Text generation, image creation, music composition.           |

### Large Language Model (LLM)

A subset of Generative AI focused specifically on understanding and generating
human language. LLMs are key drivers behind the rapid growth of GenAI. These
models are **pre-trained** or **fine-tuned** on large corpuses of text data to
produce coherent and contextually relevant text. LLMs, such as GPT, are pretrained
on massive datasets and excel at understanding and generating natural language,
making them invaluable for applications like customer support automation and
marketing copy generation.

![Predictive AI](images/Predictive-AI.png)

#### LLM Application - AI ChatBot App

In [this tutorial](LLM-chatbot-app.md), we will demonstrate how to to deploy a LLM
Application i.e. "AI ChatBot App" in [NERC OpenShift](../../openshift/index.md),
which connects to a [pre-trained foundation model](#foundation-model).

![AI ChatBot](images/AI-ChatBot.png)

However, LLMs have limitations, such as relying solely on text and lacking the
ability to understand the broader context beyond their limited window of training
data.

![RAG](images/RAG_emerge.png)

### Retrieval Augumented Generation (RAG)

Retrieval-augmented generation (RAG) is a natural language processing (NLP)
technique that enhances large language models (LLMs) by incorporating contextual
information to generate more accurate responses. In recent years, RAG has become
the de facto method for integrating enterprise or user-specific data into models.
An AI technique that enhances generative models by integrating a retrieval system
to fetch relevant documents, providing more accurate and contextually enriched responses.

!!! quote "Note"

    This IDC predicts that by 2028, 80% of RAG implementations will be used to enhance
    the accuracy and relevance of GenAI applications, and by 2026, two-thirds of
    A1000 businesses will leverage RAG to power domain-specific knowledge discovery.
    For more you can [read here](https://www.idc.com/getdoc.jsp?containerId=US51676224).

#### RAG Workflow

![RAG Workflow](images/RAG-Workflow.png)

**1. Retrieve:** The user query is used to retrieve relevant context from an
external knowledge source. For this, the user query is embedded with an embedding
model into the same vector space as the additional context in the vector database.
This allows to perform a similarity search, and the top k closest data objects
from the vector database are returned.

**2. Augment:** The user query and the retrieved additional context are stuffed
into a prompt template.

**3. Generate:** Finally, the retrieval-augmented prompt is fed to the LLM.

#### RAG Best Practices

![RAG Best Practices](images/RAG-Best-Practices.jpg)

#### RAG Application - Talk with your PDF

In [this tutorial](RAG-talk-with-your-pdf.md), we will demonstrate how to to deploy
a LLM Application i.e. "AI ChatBot App" in [NERC OpenShift](../../openshift/index.md),
which connects to a [pre-trained foundation model](#foundation-model).

![Talk with your PDF](images/talk-with-your-pdf.gif)

### Agentic AI: The Future

RAG utilizes one or more external vector databases to provide additional context
to a generative AI model when answering queries. Another emerging approach is
Agentic AI systems, which integrate multiple generative AI agents to query
external sources-such as internal databases, corporate intranets, or the
internet-ensuring models have access to the most accurate and up-to-date information.

AI Agents are autonomous systems designed to perform tasks by dynamically interacting
with data, tools, or APIs, often improving RAG workflows by executing complex,
multi-step reasoning processes. They address RAG limitations by automating task
orchestration and adapting responses based on real-time feedback and context.

![Agentic AI](images/AI-history.jpg)

---
