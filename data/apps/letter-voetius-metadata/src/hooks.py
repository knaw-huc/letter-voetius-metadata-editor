from saxonche import PySaxonProcessor, PyXdmNode
from src.profiles import prof_xml
from fastapi import Request, Response, HTTPException
import toml
import os
import logging
from src.commons import settings, convert_toml_to_xml

def transform(app: str, stylesheet: str) -> str:
    res = "This will be the response"
    with PySaxonProcessor(license=False) as proc:
        xsltproc = proc.new_xslt30_processor()
        xsltproc.set_cwd(os.getcwd())
        executable = xsltproc.compile_stylesheet(stylesheet_file=f"{settings.URL_DATA_APPS}/{app}/resources/xslt/{stylesheet}.xsl")
        executable.set_parameter("cwd", proc.make_string_value(os.getcwd()))
        executable.set_parameter("app", proc.make_string_value(app))
        config_app_file = f"{settings.URL_DATA_APPS}/{app}/config.toml"
        convert_toml_to_xml(toml_file=config_app_file,xml_file=f"{settings.URL_DATA_APPS}/{app}/config.xml")
        config = proc.parse_xml(xml_file_name=f"{settings.URL_DATA_APPS}/{app}/config.xml")
        executable.set_parameter("config", config)
        res = executable.call_template_returning_string("main")
    return res

def edges(req:Request, action:str, app: str, prof: str, nr: str, user:str) -> None:
    res = transform(app,"edges")
    return Response(content=res, media_type="text/plain")

def persons(req:Request, action:str, app: str, prof: str, nr: str, user:str) -> None:
    res = transform(app,"persons")
    return Response(content=res, media_type="text/plain")

def letters(req:Request, action:str, app: str, prof: str, nr: str, user:str) -> None:
    res = transform(app,"letters")
    return Response(content=res, media_type="text/plain")
    
 

