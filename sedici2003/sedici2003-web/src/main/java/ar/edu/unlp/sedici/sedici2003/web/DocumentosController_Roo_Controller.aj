// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.web;

import ar.edu.unlp.sedici.sedici2003.model.Documentos;
import java.io.UnsupportedEncodingException;
import java.lang.Integer;
import java.lang.String;
import java.util.Collection;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.joda.time.format.DateTimeFormat;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect DocumentosController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String DocumentosController.create(@Valid Documentos documentos, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("documentos", documentos);
            addDateTimeFormatPatterns(uiModel);
            return "documentoses/create";
        }
        uiModel.asMap().clear();
        documentos.persist();
        return "redirect:/documentoses/" + encodeUrlPathSegment(documentos.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String DocumentosController.createForm(Model uiModel) {
        uiModel.addAttribute("documentos", new Documentos());
        addDateTimeFormatPatterns(uiModel);
        return "documentoses/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String DocumentosController.show(@PathVariable("id") String id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("documentos", Documentos.findDocumentos(id));
        uiModel.addAttribute("itemId", id);
        return "documentoses/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String DocumentosController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("documentoses", Documentos.findDocumentosEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Documentos.countDocumentoses() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("documentoses", Documentos.findAllDocumentoses());
        }
        addDateTimeFormatPatterns(uiModel);
        return "documentoses/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String DocumentosController.update(@Valid Documentos documentos, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("documentos", documentos);
            addDateTimeFormatPatterns(uiModel);
            return "documentoses/update";
        }
        uiModel.asMap().clear();
        documentos.merge();
        return "redirect:/documentoses/" + encodeUrlPathSegment(documentos.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String DocumentosController.updateForm(@PathVariable("id") String id, Model uiModel) {
        uiModel.addAttribute("documentos", Documentos.findDocumentos(id));
        addDateTimeFormatPatterns(uiModel);
        return "documentoses/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String DocumentosController.delete(@PathVariable("id") String id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Documentos.findDocumentos(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/documentoses";
    }
    
    @ModelAttribute("documentoses")
    public Collection<Documentos> DocumentosController.populateDocumentoses() {
        return Documentos.findAllDocumentoses();
    }
    
    void DocumentosController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("documentos_fechadisponibilidad_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("documentos_fechahoraactualizacion_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("documentos_fechahoracreacion_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
    }
    
    String DocumentosController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        }
        catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}
