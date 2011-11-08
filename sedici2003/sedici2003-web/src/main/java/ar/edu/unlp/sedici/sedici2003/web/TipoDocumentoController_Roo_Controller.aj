// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.web;

import ar.edu.unlp.sedici.sedici2003.model.TipoDocumento;
import java.io.UnsupportedEncodingException;
import java.lang.Integer;
import java.lang.String;
import java.util.Collection;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect TipoDocumentoController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String TipoDocumentoController.create(@Valid TipoDocumento tipoDocumento, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("tipoDocumento", tipoDocumento);
            return "tipodocumentoes/create";
        }
        uiModel.asMap().clear();
        tipoDocumento.persist();
        return "redirect:/tipodocumentoes/" + encodeUrlPathSegment(tipoDocumento.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String TipoDocumentoController.createForm(Model uiModel) {
        uiModel.addAttribute("tipoDocumento", new TipoDocumento());
        return "tipodocumentoes/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String TipoDocumentoController.show(@PathVariable("id") Integer id, Model uiModel) {
        uiModel.addAttribute("tipodocumento", TipoDocumento.findTipoDocumento(id));
        uiModel.addAttribute("itemId", id);
        return "tipodocumentoes/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String TipoDocumentoController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("tipodocumentoes", TipoDocumento.findTipoDocumentoEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) TipoDocumento.countTipoDocumentoes() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("tipodocumentoes", TipoDocumento.findAllTipoDocumentoes());
        }
        return "tipodocumentoes/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String TipoDocumentoController.update(@Valid TipoDocumento tipoDocumento, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("tipoDocumento", tipoDocumento);
            return "tipodocumentoes/update";
        }
        uiModel.asMap().clear();
        tipoDocumento.merge();
        return "redirect:/tipodocumentoes/" + encodeUrlPathSegment(tipoDocumento.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String TipoDocumentoController.updateForm(@PathVariable("id") Integer id, Model uiModel) {
        uiModel.addAttribute("tipoDocumento", TipoDocumento.findTipoDocumento(id));
        return "tipodocumentoes/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String TipoDocumentoController.delete(@PathVariable("id") Integer id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        TipoDocumento.findTipoDocumento(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/tipodocumentoes";
    }
    
    @ModelAttribute("tipodocumentoes")
    public Collection<TipoDocumento> TipoDocumentoController.populateTipoDocumentoes() {
        return TipoDocumento.findAllTipoDocumentoes();
    }
    
    String TipoDocumentoController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
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
