---
layout: post
title: 'Xây Dựng Hệ Thống RAG Đầu Tiên: Hướng Dẫn Thực Hành Chi Tiết Cho Người Mới Bắt Đầu'
subtitle: Làm chủ chunking, embeddings, vector search và các chiến lược retrieval
cover-img: "/assets/img/rag-cover.jpg"
thumbnail-img: "/assets/img/ragdiagram-ezgif.com-resize.gif"
share-img: "/assets/img/rag-system-cover.png"
tags:
- rag
- ai
- vector-database
- embeddings
- postgresql
- pgvector
- ollama
- machine-learning
author: kieetnvt
lang: vi
ref: building-your-first-RAG-system
---

Bạn còn nhớ ngày xưa khi tìm kiếm chỉ là việc khớp từ khóa và hy vọng có kết quả tốt? Bạn gõ "machine learning algorithms" và nhận về những tài liệu tình cờ chứa đúng những từ đó — ngay cả khi chúng đang nói về một chủ đề hoàn toàn khác. Sau đó là những chatbot chỉ có thể trả lời câu hỏi dựa trên những gì chúng được huấn luyện, không có khả năng truy cập vào các báo cáo hay tài liệu mới nhất của công ty bạn.

Những ngày đó đang nhanh chóng qua đi! Chào mừng **RAG (Retrieval-Augmented Generation)** — một kỹ thuật đột phá cho phép các mô hình AI truy cập và suy luận trên tài liệu của bạn theo thời gian thực. Đột nhiên, chatbot của bạn có thể trả lời câu hỏi về báo cáo bán hàng quý trước, tài liệu hỗ trợ, hay toàn bộ kho kiến thức của bạn, đồng thời vẫn duy trì khả năng hội thoại thông minh của một mô hình ngôn ngữ lớn.

![Kiến Trúc Hệ Thống RAG](/assets/img/ragdiagram-ezgif.com-resize.gif "Kiến Trúc Hệ Thống RAG với Vector Database")

Tuy nhiên, có một điều: RAG có nhiều bộ phận chuyển động, và tất cả cần hoạt động trơn tru cùng nhau. Bạn phải chọn chiến lược chunking, hiểu về vector embeddings, cấu hình database, và tối ưu hóa pipeline retrieval. Nếu bạn đang xem những hướng dẫn chỉ show code cuối cùng mà không giải thích *tại sao* mọi thứ hoạt động như vậy, rất dễ cảm thấy lạc lối.

Hướng dẫn này khác. Chúng ta sẽ xây dựng hiểu biết từ nền tảng — từng khái niệm, từng thành phần. Cuối cùng, bạn không chỉ biết *cách* xây dựng hệ thống RAG, mà còn thực sự *hiểu* những gì đang diễn ra bên dưới. Sẵn sàng bắt đầu chưa? Cùng đi thôi!

## Nội Dung Sẽ Học

1. **Chunking** — chia tài liệu thành các mảnh có thể tìm kiếm
2. **Embeddings** — chuyển đổi văn bản thành semantic vectors
3. **Vector Database** — lưu trữ và tìm kiếm embeddings ở quy mô lớn
4. **Retrieval Strategies** — tìm các chunk liên quan nhất
5. **Answer Generation** — kết hợp retrieval với LLMs

---

## 01. Chunking — Chia Tài Liệu Thành Các Mảnh Có Thể Tìm Kiếm

### Vấn Đề Cần Giải Quyết

Tưởng tượng bạn upload một hướng dẫn kỹ thuật 50 trang vào hệ thống. Giờ có người hỏi: "Làm cách nào để reset thiết bị?" Câu trả lời có thể nằm đâu đó ở trang 34, trong một đoạn văn duy nhất. Nhưng vấn đề là: bạn không thể đổ cả 50 trang vào mô hình AI như context — điều đó sẽ vượt quá giới hạn token và tốn rất nhiều tiền. Thêm nữa, AI sẽ khó tập trung vào điều thực sự quan trọng khi bị ngập trong thông tin không liên quan.

Đó là lúc **chunking** xuất hiện! Bạn chia tài liệu khổng lồ đó thành những mảnh nhỏ, có ý nghĩa — có thể 500 ký tự mỗi mảnh, có thể từng đoạn văn, hoặc các phần có tính liên kết về mặt ngữ nghĩa. Giờ khi ai đó hỏi câu hỏi, bạn chỉ cần lấy 3-5 chunk liên quan nhất và đưa chúng cho AI. Hiệu quả, tập trung, và thực sự hoạt động!

**Hãy nghĩ như thế này:** Chunking giống như tổ chức một thư viện khổng lồ. Bạn không đưa ai đó cả bộ bách khoa toàn thư khi họ hỏi về hổ — bạn chỉ cho họ tập cụ thể, chương cụ thể và trang cụ thể. Ý tưởng giống vậy! Bạn đang tạo một chỉ mục giúp tìm đúng thông tin cực nhanh.

### Năm Chiến Lược Chunking

### Năm Chiến Lược Chunking

Các tài liệu khác nhau cần các cách tiếp cận khác nhau. Đây là năm lựa chọn chính của bạn:

#### 1. **Fixed-Size Chunking** (Tốt nhất cho mục đích chung)

Chia văn bản thành các chunk có kích thước bằng nhau với overlap tùy chọn. Đơn giản, dự đoán được, và hoạt động tốt cho hầu hết các trường hợp.

```javascript
// Ví dụ: 500 ký tự mỗi chunk, 50 ký tự overlap
{
  "strategy": "fixed",
  "chunkSize": 500,
  "overlap": 50
}

// Kết quả:
// Chunk 1: [0-500]
// Chunk 2: [450-950]   ← overlap với chunk 1!
// Chunk 3: [900-1400]
```

**Ưu điểm:** Kích thước nhất quán, nhanh, dự đoán được
**Nhược điểm:** Có thể cắt câu hoặc khái niệm một cách vụng về

#### 2. **Sentence-Based Chunking** (Tốt nhất cho Q&A)

Nhóm các câu hoàn chỉnh lại với nhau cho đến khi đạt kích thước mục tiêu. Không bao giờ cắt giữa câu!

```javascript
// Nhóm câu lên tới ~500 ký tự
{
  "strategy": "sentence",
  "targetSize": 500,
  "maxSize": 800
}

// Kết quả:
// Chunk 1: "Con mèo ngồi trên chiếu. Đó là một ngày nắng đẹp. Chim chóc đang hót."
// Chunk 2: "Đột nhiên, một con chó xuất hiện. Con mèo nhảy lên nhanh chóng."
```

**Ưu điểm:** Mạch lạc, ranh giới tự nhiên
**Nhược điểm:** Kích thước chunk thay đổi

#### 3. **Paragraph-Based Chunking** (Tốt nhất cho tài liệu có cấu trúc)

Giữ nguyên các đoạn văn, bảo toàn cấu trúc do tác giả định sẵn.

```javascript
{
  "strategy": "paragraph",
  "minSize": 100,
  "maxSize": 1000
}
```

**Ưu điểm:** Bảo toàn cấu trúc tài liệu, duy trì ngữ cảnh
**Nhược điểm:** Kích thước rất thay đổi

#### 4. **Semantic Chunking** (Tốt nhất cho chủ đề phức tạp)

Lựa chọn thông minh nhất! Kết hợp nhận thức về câu và đoạn văn với overlap thông minh tại các ranh giới tự nhiên.

```javascript
{
  "strategy": "semantic",
  "targetSize": 500,
  "overlapSentences": 1
}
```

**Ưu điểm:** Bảo toàn ngữ cảnh tốt nhất, chia tách tự nhiên
**Nhược điểm:** Phức tạp hơn, tốn kém về mặt tính toán

#### 5. **Token-Based Chunking** (Tốt nhất cho giới hạn LLM)

Chia theo số lượng token (khoảng 4 ký tự = 1 token) để phù hợp chính xác với context window của model.

```javascript
{
  "strategy": "token",
  "maxTokens": 500,
  "overlapTokens": 50
}
```

**Ưu điểm:** Kiểm soát chính xác cho các ràng buộc của LLM
**Nhược điểm:** Gần đúng (sử dụng ước tính ký tự)

### Khi Nào Dùng Chiến Lược Nào

| Chiến Lược | Sử Dụng Khi... |
|----------|------------|
| **Fixed** | Tài liệu đa mục đích, hiệu suất cân bằng |
| **Sentence** | Hệ thống Q&A, chatbot, hội thoại tự nhiên |
| **Paragraph** | Tài liệu có cấu trúc tốt (báo cáo, bài viết) |
| **Semantic** | Chủ đề phức tạp cần ngữ cảnh tối đa |
| **Token** | Giới hạn token nghiêm ngặt (GPT-3.5, v.v.) |

### Phép Màu Của Overlap

Đây là một mẹo pro tạo nên sự khác biệt lớn: **luôn thêm overlap giữa các chunk!** Tại sao? Vì câu trả lời thường nằm ở ranh giới. Nếu bạn cắt "Thiết bị có thể được reset bằng cách giữ nút nguồn trong 10 giây" ngay giữa, cả hai chunk đều không có nghĩa hoàn chỉnh. Nhưng với overlap 50-100 ký tự, cả hai chunk đều chứa câu trả lời đầy đủ.

**Ví dụ thực tế:** Overlap giống như phụ đề trên video còn lưu lại một giây sau khi người nói chuyển sang nội dung khác. Nó tạo ra tính liên tục và đảm bảo bạn không bao giờ bỏ lỡ ngữ cảnh, ngay cả khi cảnh thay đổi!

**⚠️ Lưu ý!** Chunk quá nhỏ (<100 ký tự) mất ngữ cảnh và ý nghĩa. Chunk quá lớn (>2000 ký tự) giảm độ chính xác — bạn sẽ lấy quá nhiều thông tin không liên quan. Điểm tối ưu cho hầu hết trường hợp? **300-800 ký tự với 10-20% overlap**.

---

## 02. Embeddings — Chuyển Đổi Văn Bản Thành Semantic Vectors

### Vấn Đề Cần Giải Quyết

Máy tính không hiểu ý nghĩa — chúng chỉ hiểu số. Nếu bạn hỏi "Làm cách nào để reset mật khẩu?" và một tài liệu nói "Làm theo các bước sau để lấy lại quyền truy cập tài khoản," tìm kiếm từ khóa truyền thống sẽ thất bại thảm hại (không có từ nào khớp!). Nhưng con người ngay lập tức nhận ra đây là những khái niệm liên quan.

**Embeddings** giải quyết vấn đề này bằng cách chuyển đổi văn bản thành các vector số đa chiều nắm bắt ý nghĩa ngữ nghĩa. Các khái niệm tương tự nằm gần nhau trong không gian vector, ngay cả khi chúng sử dụng các từ hoàn toàn khác nhau. Giống như cho máy tính một "la bàn ý nghĩa" chỉ các ý tưởng tương tự về phía nhau!

**Hãy tưởng tượng:** Một không gian 3D rộng lớn (thực ra là 768 chiều, nhưng hãy giữ nó đơn giản). Mọi khái niệm có thể có đều có một vị trí trong không gian này. "Mèo" và "mèo con" là những người hàng xóm rất gần. "Mèo" và "vật lý lượng tử" ở hai phía đối diện của vũ trụ. Khi bạn embed văn bản, bạn đang tìm tọa độ của nó trong không gian ngữ nghĩa này. Giờ việc tìm kiếm trở nên đơn giản như tìm hàng xóm!

### Cách Embeddings Hoạt Động

Mô hình embedding (`nomic-embed-text` trong trường hợp của chúng ta) nhận bất kỳ chuỗi văn bản nào và xuất ra một vector 768 chiều — về cơ bản là một danh sách 768 số từ -1 đến 1.

```javascript
// Văn bản đầu vào
"Machine learning is a subset of artificial intelligence"

// Được chuyển đổi thành:
[0.234, -0.456, 0.678, 0.123, -0.891, ..., 0.045]
//  ^---- Tổng cộng 768 số ----^

// Văn bản tương tự tạo ra vector tương tự!
"AI and ML are related fields"
[0.241, -0.449, 0.685, 0.135, -0.883, ..., 0.052]
//  ↑ Để ý các số rất gần nhau!
```

### Tìm Kiếm Tương Đồng Trong Thực Tế

Khi mọi thứ đã được embed, việc tìm chunk liên quan chỉ là toán học vector:

```javascript
// Người dùng hỏi: "Nói cho tôi về mèo"
Query Vector:    [0.21, -0.42, 0.71, ...]

Database Chunks:
Chunk 1: "Con mèo ngồi trên chiếu..."
Vector:          [0.23, -0.45, 0.67, ...]  → 95% tương tự ✅

Chunk 2: "Chó là bạn đồng hành trung thành..."
Vector:          [0.12, -0.33, 0.24, ...]  → 65% tương tự

Chunk 3: "Vật lý lượng tử giải thích..."
Vector:          [-0.45, 0.87, -0.23, ...] → 8% tương tự

Được lấy: Chunk 1 (liên quan nhất!)
```

### Toán Học Đằng Sau Độ Tương Đồng

Thước đo phổ biến nhất là **cosine similarity** — nó đo góc giữa hai vector. Nghĩ về nó như thế này: hai vector cùng hướng (ý nghĩa tương tự) có góc nhỏ và độ tương đồng cao. Các vector hướng ngược nhau (không liên quan) có góc lớn và độ tương đồng thấp.

```sql
-- PostgreSQL với pgvector
-- Toán tử <=> tính khoảng cách cosine (1 - similarity)
SELECT
  content,
  1 - (embedding <=> query_vector) as similarity,
  (1 - (embedding <=> query_vector)) * 100 as percentage
FROM document_chunks
WHERE embedding IS NOT NULL
ORDER BY embedding <=> query_vector
LIMIT 5;
```

### Khi Nào Dùng Embeddings

- Tìm kiếm ngữ nghĩa (dựa trên ý nghĩa, không phải khớp từ khóa)
- Tìm tài liệu hoặc đoạn văn tương tự
- Hỏi đáp trên kho văn bản lớn
- Hệ thống gợi ý

### Khi KHÔNG Nên Dùng Embeddings

- Bạn cần khớp từ khóa chính xác (dùng full-text search)
- Câu truy vấn rất ngắn (3-5 từ) — có thể thiếu ngữ cảnh ngữ nghĩa
- Ràng buộc thời gian thực không có cache (embedding có thể chậm)

**⚠️ Hiểu biết quan trọng:** Embeddings nắm bắt *ý nghĩa ngữ nghĩa*, không phải độ chính xác thực tế. Mô hình không "biết" liệu cái gì là đúng hay sai — nó chỉ biết những khái niệm nào liên quan. Đó là lý do tại sao hệ thống RAG vẫn cần retrieval tốt và một LLM có năng lực để tổng hợp câu trả lời chính xác!

**💡 Mẹo pro:** Luôn sử dụng **cùng một mô hình embedding** cho cả những chunk tài liệu và câu truy vấn. Trộn lẫn các mô hình tạo ra các vector trong không gian ngữ nghĩa khác nhau — giống như cố gắng sử dụng tọa độ GPS từ Trái Đất trên bản đồ Sao Hỏa. Nó sẽ không hoạt động! Hãy giữ một mô hình nhất quán.

---

## 03. Vector Database — Lưu Trữ và Tìm Kiếm ở Quy Mô Lớn

### Vấn Đề Cần Giải Quyết

Bạn đã chia tài liệu và embed chúng thành các vector 768 chiều. Tuyệt vời! Nhưng giờ bạn có một vấn đề mới: làm cách nào để nhanh chóng tìm những hàng xóm gần nhất trong số hàng triệu vector tiềm năng? So sánh query vector của bạn với từng chunk một sẽ mất mãi mãi — và chúng ta đang nói về mức "đến khi vũ trụ lạnh cứng" ở quy mô lớn.

Giới thiệu **vector database**! Sử dụng các thuật toán indexing chuyên biệt (như HNSW), nó có thể tìm những hàng xóm gần đúng (approximate) trong vài mili giây, ngay cả với dataset khổng lồ. Hãy nghĩ về nó như một công cụ tìm kiếm siêu nạp turbo được thiết kế đặc biệt cho toán học đa chiều.

**Đây là một so sánh hay:** Tưởng tượng bạn đang trong thư viện với một triệu cuốn sách, và bạn cần tìm 5 cuốn giống nhất với cuốn bạn đang cầm. Không có hệ thống chỉ mục, bạn sẽ so sánh cuốn sách của mình với cả triệu cuốn khác từng cuốn một. Với vector database (danh mục thẻ sách của thư viện nhưng mạnh hơn nhiều), bạn nhảy thẳng đến đúng khu vực, kệ sách và những cuốn kề bên. Chính xác giống nhau, nhanh hơn 1000 lần!

### Tại Sao PostgreSQL + pgvector?

Chúng ta sử dụng PostgreSQL với extension `pgvector`, và đây là lý do tại sao nó tuyệt vời:

1. **Không cần database riêng** — Thêm tìm kiếm vector vào thiết lập PostgreSQL hiện tại của bạn
2. **SQL + vectors cùng nhau** — Lọc theo metadata VÀ độ tương đồng trong một truy vấn
3. **HNSW indexing** — Thuật toán dựa trên đồ thị cho tìm kiếm gần đúng nhanh
4. **Đã được chứng minh trong production** — Được sử dụng bởi các công ty xử lý hàng tỷ vector

### Thiết Lập Lưu Trữ Vector

```sql
-- Kích hoạt extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Tạo bảng chunks với cột vector
CREATE TABLE document_chunks (
  id UUID PRIMARY KEY,
  document_id UUID REFERENCES documents(id),
  content TEXT,
  chunk_index INTEGER,
  embedding vector(768),  -- Vector 768 chiều!
  metadata JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Tạo index HNSW cho tìm kiếm tương đồng nhanh
CREATE INDEX idx_chunks_embedding ON document_chunks
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);
```

### Giải Thích HNSW Index

**HNSW (Hierarchical Navigable Small World)** là một thuật toán dựa trên đồ thị tạo index nhiều lớp:

- **Lớp dưới:** Mọi vector kết nối với các hàng xóm gần nhất
- **Các lớp trên:** "Xa lộ" nhảy qua không gian để di chuyển nhanh
- **Tìm kiếm:** Bắt đầu từ trên, zoom vào vùng đúng, chi tiết hóa để có độ chính xác

```
Layer 2:  A ←----------→ B        (xa lộ)
          ↓              ↓
Layer 1:  A ←→ C ←→ D ←→ B        (đường trung bình)
          ↓    ↓    ↓    ↓
Layer 0:  A→C→D→E→F→G→H→B        (tất cả hàng xóm)
```

**Tham số:**
- `m = 16` — Số kết nối tối đa mỗi node (cao hơn = chính xác hơn, build chậm hơn)
- `ef_construction = 64` — Độ sâu tìm kiếm khi tạo index (cao hơn = chất lượng tốt hơn)

### Các Toán Tử Độ Tương Đồng Vector

| Toán Tử | Kiểu Khoảng Cách | Công Thức | Trường Hợp Sử Dụng |
|----------|--------------|---------|----------|
| `<=>` | Cosine | `1 - cosine_similarity` | **Chính** — Độ tương đồng ngữ nghĩa |
| `<->` | Euclidean (L2) | `sqrt(sum((a-b)²))` | Khoảng cách hình học |
| `<#>` | Inner Product | `sum(a * b)` | Vector đã chuẩn hóa |

### Truy Vấn Vector Database

```sql
-- Tìm top 5 chunk tương đồng nhất
SELECT
  id,
  content,
  1 - (embedding <=> $1::vector) as similarity
FROM document_chunks
WHERE 1 - (embedding <=> $1::vector) >= 0.5  -- Chỉ khớp 50%+
ORDER BY embedding <=> $1::vector
LIMIT 5;
```

### Nâng Cao: Lọc Theo Metadata

Phép màu của SQL + vectors: kết hợp tìm kiếm ngữ nghĩa với bộ lọc truyền thống!

```sql
-- Tìm chunk tương tự từ tài liệu cụ thể, chỉ mới đây
SELECT *
FROM document_chunks
WHERE
  document_id = '123e4567-e89b-12d3-a456-426614174000'
  AND created_at > NOW() - INTERVAL '30 days'
  AND 1 - (embedding <=> $1::vector) >= 0.6
ORDER BY embedding <=> $1::vector
LIMIT 3;
```

### Khi Nào Dùng Vector Database

- Tìm kiếm hàng nghìn đến hàng triệu vector
- Cần thời gian truy vấn dưới 1 giây
- Kết hợp tìm kiếm ngữ nghĩa với bộ lọc
- Hệ thống RAG trong production

### Khi KHÔNG Nên Dùng

- Dataset nhỏ (<1000 vector) — tìm kiếm tuyến tính ổn
- Cần khớp chính xác (dùng index truyền thống)
- Cập nhật embedding theo thời gian thực (reindex tốn kém)

**⚠️ Mẹo hiệu suất:** HNSW index được **tối ưu hóa cho đọc**. Việc build hoặc cập nhật index trên hàng triệu vector có thể mất thời gian. Đối với hệ thống ghi thường xuyên, hãy cân nhắc batch các cập nhật và rebuild index trong giờ vắng. Hoặc khám phá các phương pháp hybrid nơi vector mới dùng tìm kiếm tuyến tính cho đến lần rebuild index tiếp theo.

**💡 Hiểu biết về lưu trữ:** Một vector 768 chiều chiếm khoảng 3KB lưu trữ (768 float × 4 byte). Vì vậy một triệu chunk = ~3GB chỉ cho embeddings. Lên kế hoạch lưu trữ phù hợp, và sử dụng HNSW index để giữ truy vấn nhanh bất chấp kích thước dữ liệu!

---

## 04. Retrieval Strategies — Tìm Đúng Những Chunk

### Vấn Đề Cần Giải Quyết

Bạn đã có tài liệu được chia, embedded và đánh index. Ai đó hỏi một câu hỏi, và bạn cũng embed nó. Giờ đến quyết định quan trọng: **bạn thực sự retrieve những chunk nào và gửi cho LLM?** Quá ít chunk và bạn có thể bỏ lỡ câu trả lời. Quá nhiều và bạn nhấn chìm LLM trong nhiễu, lãng phí token, và làm chậm mọi thứ.

Chiến lược retrieval là nghệ thuật và khoa học của việc quyết định chính xác chunk nào được chọn. Làm đúng, và hệ thống RAG sẽ cho câu trả lời chính xác. Làm sai, và bạn sẽ debug tại sao AI cứ nói về chủ đề sai!

**Hãy nghĩ như thế này:** Bạn là một luật sư chuẩn bị vụ án. Bạn có thể đổ mọi tài liệu từ khám phá lên bàn của thẩm phán (quá tải), hoặc bạn có thể chọn kỹ  3-5 bằng chứng quan trọng nhất (hiệu quả). Chiến lược retrieval là cách bạn quyết định bằng chứng nào được đưa ra tòa!

### Chiến Lược 1: Top-K Retrieval

Cách tiếp cận đơn giản nhất: retrieve K chunk với điểm tương đồng cao nhất, bất kể chúng thực sự tương đồng như thế nào.

```javascript
// Ví dụ: Lấy top 5 chunk, hết
{
  "topK": 5,
  "similarityThreshold": 0.0  // Không yêu cầu tối thiểu
}

// Kết quả:
// Chunk 1: 92% tương tự ✅
// Chunk 2: 87% tương tự ✅
// Chunk 3: 81% tương tự ✅
// Chunk 4: 34% tương tự ❓ (bao gồm nhưng có lẽ không hữu dụng)
// Chunk 5: 12% tương tự ❌ (nhiễu!)
```

**Tốt nhất cho:** Khi bạn PHẢI có chính xác K kết quả (ví dụ: UI hiển thị 5 nguồn)
**Lưu ý:** Có thể bao gồm những kết quả chất lượng thấp nếu không có gì rất liên quan

### Chiến Lược 2: Threshold-Based Retrieval

Chỉ retrieve chunk trên ngưỡng tương đồng tối thiểu. Bạn có thể nhận 1 kết quả hoặc 20 — bất cứ cái gì đạt tiêu chuẩn.

```javascript
// Ví dụ: Chỉ kết quả chất lượng cao
{
  "topK": 999,  // Thực tế là không giới hạn
  "similarityThreshold": 0.7  // Tối thiểu 70% tương đồng
}

// Kết quả (từ cùng truy vấn như trên):
// Chunk 1: 92% tương tự ✅
// Chunk 2: 87% tương tự ✅
// Chunk 3: 81% tương tự ✅
// (Chunk 4 & 5 bị loại — dưới ngưỡng)
```

**Tốt nhất cho:** Khi chất lượng quan trọng hơn số lượng
**Lưu ý:** Có thể trả về 0 kết quả nếu ngưỡng quá cao

### Chiến Lược 3: Hybrid (Tốt Nhất Của Cả Hai)

Kết hợp cả hai cách: đặt ngưỡng VÀ số lượng tối đa.

```javascript
// Ví dụ: Tối đa 5 chunk, nhưng chỉ nếu chúng tốt
{
  "topK": 5,
  "similarityThreshold": 0.5  // Tối thiểu 50% tương đồng
}

// Kết quả:
// Chunk 1: 92% tương tự ✅
// Chunk 2: 87% tương tự ✅
// Chunk 3: 81% tương tự ✅
// Chunk 4: 56% tương tự ✅
// (Dừng ở 4 — chunk 5 chỉ có 12%, dưới ngưỡng)
```

**Tốt nhất cho:** Hệ thống production — cân bằng chất lượng và tính nhất quán
**Đây là lựa chọn mặc định được khuyến nghị!**

### Giải Thích Điểm Tương Đồng

Những tỉ lệ phần trăm đó thực sự có nghĩa là gì?

| Điểm | Ý Nghĩa | Hành Động |
|-------|---------|--------|
| **90-100%** | Khớp ngữ nghĩa gần chính xác | Chắc chắn dùng |
| **70-89%** | Liên quan mạnh | Thường dùng |
| **50-69%** | Liên quan trung bình | Tùy ngữ cảnh |
| **30-49%** | Kết nối yếu | Thường loại |
| **0-29%** | Cơ bản không liên quan | Chắc chắn loại |

### Nâng Cao: Xây Dựng Context Cho LLM

Khi đã retrieve được chunk, bạn cần định dạng chúng đẹp cho LLM:

```javascript
// Các chunk đã retrieve
const chunks = [
  { content: "ML là một tập con của AI...", similarity: 0.92 },
  { content: "Các thuật toán chính bao gồm...", similarity: 0.87 },
  { content: "Ứng dụng trải rộng...", similarity: 0.81 }
];

// Xây dựng chuỗi context
const context = chunks
  .map((chunk, i) => `[Nguồn ${i+1} - ${(chunk.similarity*100).toFixed(0)}% khớp]\n${chunk.content}`)
  .join('\n\n---\n\n');

// Prompt cho LLM
const prompt = `
Context từ các tài liệu liên quan:

${context}

Câu Hỏi: ${query}

Vui lòng trả lời dựa trên context đã cung cấp. Nếu context không chứa đủ thông tin, hãy nói vậy.
`;
```

### Khi Nào Dùng Mỗi Chiến Lược

| Chiến Lược | Sử Dụng Khi... |
|----------|-------------|
| **Top-K only** | UI cần số lượng cố định, đa dạng quan trọng |
| **Threshold only** | Chất lượng là thiên yếu, số lượng thay đổi OK |
| **Hybrid** | Cân bằng sẵn sàng cho production (khuyến nghị) |

### Mẹo Điều Chỉnh Retrieval

1. **Bắt đầu thận trọng:** `topK=5, threshold=0.5` hoạt động cho hầu hết các trường hợp
2. **Hạ ngưỡng** nếu bạn nhận câu trả lời "Tôi không biết" (quá hạn chế)
3. **Tăng ngưỡng** nếu câu trả lời chứa thông tin không liên quan (quá rộng)
4. **Tăng topK** cho câu hỏi phức tạp cần nhiều quan điểm
5. **Theo dõi điểm tương đồng** trong production — chúng tiết lộ vấn đề chất lượng dữ liệu

**⚠️ Vấn đề cold start:** Tài liệu hoàn toàn mới không có lịch sử truy vấn sẽ chưa có điểm tương đồng được hiệu chỉnh. Bắt đầu với ngưỡng thấp hơn (0.3-0.4) và thắt chặt nó khi bạn thu thập dữ liệu về điểm nào thực sự chỉ ra sự liên quan cho tài liệu CỤ THỂ của bạn.

**💡 Vũ khí bí mật — lọc metadata:** Đôi khi độ tương đồng ngữ nghĩa không đủ. Kết hợp nó với bộ lọc! Ví dụ: "Tìm chunk tương tự từ tài liệu được upload trong tuần qua VÀ được gắn thẻ 'engineering' VÀ similarity > 70%." Đây là nơi PostgreSQL tỏa sáng — SQL + vectors trong một truy vấn!

---

## 05. Answer Generation — Kết Hợp Tất Cả Lại

### Vấn Đề Cần Giải Quyết

Bạn đã tìm được những chunk hoàn hảo — cực kỳ liên quan, tương đồng về mặt ngữ nghĩa, chứa đầy thông tin. Nhưng chúng chỉ là những đoạn văn bản thô! Người dùng hỏi câu hỏi bằng ngôn ngữ tự nhiên và mong đợi câu trả lời bằng ngôn ngữ tự nhiên, không phải một đống những mảnh tài liệu. Thêm nữa, các chunk có thể sử dụng thuật ngữ kỹ thuật, được định dạng như dấu đầu dòng, hoặc thiếu ngữ cảnh kết nối.

Bước cuối cùng này là nơi **LLM (Large Language Model)** thực hiện phép màu. Bạn đưa nó các chunk đã retrieve làm context cùng với câu hỏi của người dùng, và nó tổng hợp một câu trả lời mạch lạc, dạng hội thoại bằng ngôn ngữ tự nhiên. Giống như có một trợ lý nghiên cứu đọc tất cả các đoạn liên quan và viết cho bạn một bản tóm tắt hay!

**So sánh hay:** Retrieval giống như người thư viện nghiên cứu lấy những cuốn sách đúng và đánh dấu các trang liên quan cho bạn. Answer generation là bạn thực sự đọc những trang đó và viết bài luận của bạn. Người thư viện tìm sự thật; bạn biến chúng thành câu chuyện!

### The Complete RAG Pipeline

Let's trace a question end-to-end:

```
1. User Question
   ↓
   "What is machine learning?"

2. Embed Query
   ↓
   [0.234, -0.456, 0.678, ..., 0.123]

3. Vector Search (topK=5, threshold=0.5)
   ↓
   Chunk 1: "Machine learning is a subset..." (92% match)
   Chunk 2: "Key ML algorithms include..."    (87% match)
   Chunk 3: "Applications of ML span..."      (81% match)

4. Build Context
   ↓
   [Source 1 - 92% match]
   Machine learning is a subset...

   [Source 2 - 87% match]
   Key ML algorithms include...

   [Source 3 - 81% match]
   Applications of ML span...

5. Generate Answer (LLM)
   ↓
   "Machine learning is a subset of artificial intelligence
   that enables computers to learn from data without explicit
   programming. Common algorithms include decision trees,
   neural networks, and support vector machines. It's widely
   used in recommendation systems, image recognition, and
   natural language processing."

6. Return to User (with citations!)
   ↓
   Answer + Source chunks for transparency
```

### Prompt Engineering for RAG

The prompt structure matters! Here's a production-ready template:

```javascript
const systemPrompt = `You are a helpful assistant that answers questions based on provided context.

RULES:
1. Answer ONLY using information from the context below
2. If the context doesn't contain enough info, say "I don't have enough information to answer that"
3. Cite sources by referencing [Source 1], [Source 2], etc.
4. Be concise but complete
5. If multiple sources contradict, mention both perspectives`;

const userPrompt = `
Context from relevant documents:

${contextChunks}

---

User Question: ${query}

Please provide an accurate answer based on the context above.
`;

// Call the LLM
const response = await ollama.chat({
  model: 'qwen3:0.6b',
  messages: [
    { role: 'system', content: systemPrompt },
    { role: 'user', content: userPrompt }
  ]
});
```

### Tracking Everything in the Database

Good RAG systems log every query for analytics and debugging:

```sql
-- rag_queries table stores complete query history
INSERT INTO rag_queries (
  id,
  query,
  query_embedding,
  document_id,
  retrieved_chunks,     -- Array of chunk IDs used
  answer,
  model,
  retrieval_strategy,
  top_k,
  similarity_threshold,
  response_time_ms,
  user_id
) VALUES (
  gen_random_uuid(),
  'What is machine learning?',
  '[0.234, -0.456, ...]'::vector,
  'doc-uuid',
  ARRAY['chunk-1-uuid', 'chunk-2-uuid', 'chunk-3-uuid'],
  'Machine learning is...',
  'qwen3:0.6b',
  'hybrid',
  5,
  0.5,
  1234,
  'user-123'
);
```

### Why Log Queries?

1. **Debug poor answers** — See exactly which chunks were retrieved
2. **Optimize retrieval** — Analyze similarity score distributions
3. **A/B test strategies** — Compare different `topK` and threshold settings
4. **Monitor performance** — Track response times and identify bottlenecks
5. **Build training data** — Collect human feedback on answer quality

### Handling Edge Cases

**No relevant chunks found:**
```javascript
if (retrievedChunks.length === 0) {
  return {
    answer: "I couldn't find any relevant information in the documents to answer that question.",
    chunks: [],
    confidence: 0
  };
}
```

**Low confidence results:**
```javascript
const avgSimilarity = chunks.reduce((sum, c) => sum + c.similarity, 0) / chunks.length;

if (avgSimilarity < 0.6) {
  return {
    answer: response + "\n\n⚠️ Note: This answer is based on moderately relevant sources. Please verify important details.",
    chunks: retrievedChunks,
    confidence: avgSimilarity
  };
}
```

**Hallucination prevention:**
```javascript
const systemPrompt = `CRITICAL: You must ONLY use information from the provided context.
Do NOT add information from your training data.
If you're not sure, say "I'm not sure" rather than guessing.`;
```

### When to Use RAG

- Answering questions over proprietary/recent documents
- Customer support chatbots with access to knowledge bases
- Research assistants for large document collections
- Any Q&A where facts need to be grounded in specific sources

### When NOT to Use RAG

- General knowledge questions (just use the LLM directly)
- Real-time data that changes faster than you can re-embed
- Tiny datasets where retrieval overhead isn't worth it

**⚠️ The hallucination trap:** Even with perfect retrieval, LLMs can still "make stuff up" by mixing retrieved context with their training data. Combat this with strong system prompts that emphasize context-only answers, and always show users the source chunks so they can verify information themselves!

**💡 Pro tip — streaming responses:** For better UX, stream the LLM's response token-by-token rather than waiting for the full answer. Users see progress immediately and can start reading while the model finishes. Most LLM APIs (including Ollama) support streaming with minimal code changes!

---

## Putting It All Together: Your RAG System Checklist

And there you have it! You've journeyed through the complete RAG pipeline from raw documents to intelligent answers. Here's your quick reference recap:

| Component | What It Does | Key Decisions |
|-----------|-------------|---------------|
| **Chunking** | Split docs into searchable pieces | Strategy (fixed/sentence/semantic), size (300-800 chars), overlap (10-20%) |
| **Embeddings** | Convert text to 768-dim vectors | Model (nomic-embed-text), consistency (same model everywhere) |
| **Vector DB** | Store and search millions of vectors | Index type (HNSW), distance metric (cosine), filters (metadata SQL) |
| **Retrieval** | Find most relevant chunks | Strategy (hybrid), topK (5), threshold (0.5) |
| **Generation** | Synthesize natural answers | LLM (qwen3:0.6b), prompt (context-only), citations (source tracking) |

### Your First RAG System in 5 Commands

```bash
# 1. Pull the embedding model
curl -X POST http://localhost:11434/api/pull \
  -d '{"name":"nomic-embed-text"}'

# 2. Check system status
curl http://localhost:4000/api/rag/status

# 3. Upload a document
curl -X POST http://localhost:4000/api/rag/upload \
  -F "file=@document.pdf" \
  -F "chunkStrategy=semantic" \
  -F "chunkSize=500" \
  -F "overlap=50"

# 4. Query your documents
curl -X POST http://localhost:4000/api/rag/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What is the main topic?",
    "topK": 5,
    "similarityThreshold": 0.5,
    "includeChunks": true
  }'

# 5. Celebrate! 🎉 You built a RAG system!
```

### What You've Mastered

✅ How chunking strategies affect retrieval quality
✅ Why embeddings capture semantic meaning, not keywords
✅ How vector databases make similarity search blazing fast
✅ What similarity scores actually mean and how to tune them
✅ How to combine retrieval + LLMs for grounded answers
✅ Production patterns: logging, monitoring, error handling

### Next-Level Challenges

Ready to take this further? Try these:

1. **Multi-document knowledge base** — Index your entire company wiki or docs
2. **Re-ranking** — Add a second-pass LLM to re-order chunks by true relevance
3. **Hybrid search** — Combine vector search with traditional keyword search (BM25)
4. **Conversation memory** — Make your RAG chatbot remember previous messages
5. **Multimodal RAG** — Extend to images, tables, and diagrams
6. **Evaluation pipeline** — Build automated tests for answer quality
7. **Real-time updates** — Efficiently handle document updates without full re-indexing

### The Most Important Lesson

RAG isn't magic — it's a pipeline with tunable components. When answers aren't great, **measure and debug systematically:**

- Bad chunks? Adjust chunking strategy
- Wrong chunks retrieved? Tune similarity threshold
- Right chunks, wrong answer? Improve prompt engineering
- Too slow? Optimize index parameters or reduce topK
- Inconsistent? Add logging and monitor distributions

The best way to learn is to build and iterate! Start small, upload a few documents, ask questions, inspect what chunks get retrieved, see what the LLM does with them. Every weird edge case you debug will deepen your understanding exponentially.

**You've got all the knowledge you need now. Go build something amazing! 🚀**

### Resources to Keep Learning

- [pgvector GitHub](https://github.com/pgvector/pgvector) — Vector extension docs
- [Ollama Embeddings API](https://github.com/ollama/ollama/blob/main/docs/api.md#generate-embeddings) — API reference
- [HNSW Paper](https://arxiv.org/abs/1603.09320) — Deep dive into the algorithm
- [RAG Paper (Lewis et al.)](https://arxiv.org/abs/2005.11401) — Original research
- [Anthropic's RAG Guide](https://www.anthropic.com/index/contextual-retrieval) — Production best practices

**Happy building, and welcome to the world of RAG! 🎓**
