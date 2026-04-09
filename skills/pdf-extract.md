name: pdf-extract
description: Extract structured data from engineering/municipal PDFs
allowed-tools: Bash Read Write

Steps:
1. Check page count — under 20 pages use Read tool, over 20 use pdf-mcp
2. Identify structure (tables, text blocks, form fields)
3. MUST use pdfplumber for table extraction — never tabula
4. pytesseract as OCR fallback for scanned pages only
5. For scanned PDFs with no text layer, convert pages to images and use Claude vision
6. Output structured CSV/JSON with headers matching target schema
7. Validate row counts and data types before returning
