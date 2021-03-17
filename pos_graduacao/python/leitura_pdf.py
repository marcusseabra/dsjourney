# https://automatetheboringstuff.com/chapter13/
# https://towardsdatascience.com/how-to-extract-text-from-pdf-245482a96de7
# https://pdfminersix.readthedocs.io/en/latest/tutorial/composable.html

# https://github.com/jsvine/pdfplumber


from pdfminer3.layout import LAParams, LTTextBox
from pdfminer3.pdfpage import PDFPage
from pdfminer3.pdfinterp import PDFResourceManager
from pdfminer3.pdfinterp import PDFPageInterpreter
from pdfminer3.converter import PDFPageAggregator
from pdfminer3.converter import TextConverter
import io

resource_manager = PDFResourceManager()
fake_file_handle = io.StringIO()
converter = TextConverter(resource_manager, fake_file_handle, laparams=LAParams())
page_interpreter = PDFPageInterpreter(resource_manager, converter)

with open('/home/seabra/Documentos/IR_2021/Notas_Negociacao/Nota_Negociacao_2020-01-30.pdf', 'rb') as fh:

    for page in PDFPage.get_pages(fh,
                                  caching=True,
                                  check_extractable=True):
        page_interpreter.process_page(page)

    text = fake_file_handle.getvalue()

# close open handles
converter.close()
fake_file_handle.close()

print(text)
