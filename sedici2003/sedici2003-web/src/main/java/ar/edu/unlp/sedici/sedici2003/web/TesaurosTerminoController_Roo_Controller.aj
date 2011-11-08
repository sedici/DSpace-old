// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.web;

import ar.edu.unlp.sedici.sedici2003.model.TesaurosTermino;
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

privileged aspect TesaurosTerminoController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String TesaurosTerminoController.create(@Valid TesaurosTermino tesaurosTermino, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("tesaurosTermino", tesaurosTermino);
            return "tesaurosterminoes/create";
        }
        uiModel.asMap().clear();
        tesaurosTermino.persist();
        return "redirect:/tesaurosterminoes/" + encodeUrlPathSegment(tesaurosTermino.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String TesaurosTerminoController.createForm(Model uiModel) {
        uiModel.addAttribute("tesaurosTermino", new TesaurosTermino());
        return "tesaurosterminoes/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String TesaurosTerminoController.show(@PathVariable("id") String id, Model uiModel) {
        uiModel.addAttribute("tesaurostermino", TesaurosTermino.findTesaurosTermino(id));
        uiModel.addAttribute("itemId", id);
        return "tesaurosterminoes/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String TesaurosTerminoController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("tesaurosterminoes", TesaurosTermino.findTesaurosTerminoEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) TesaurosTermino.countTesaurosTerminoes() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("tesaurosterminoes", TesaurosTermino.findAllTesaurosTerminoes());
        }
        return "tesaurosterminoes/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String TesaurosTerminoController.update(@Valid TesaurosTermino tesaurosTermino, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("tesaurosTermino", tesaurosTermino);
            return "tesaurosterminoes/update";
        }
        uiModel.asMap().clear();
        tesaurosTermino.merge();
        return "redirect:/tesaurosterminoes/" + encodeUrlPathSegment(tesaurosTermino.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String TesaurosTerminoController.updateForm(@PathVariable("id") String id, Model uiModel) {
        uiModel.addAttribute("tesaurosTermino", TesaurosTermino.findTesaurosTermino(id));
        return "tesaurosterminoes/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String TesaurosTerminoController.delete(@PathVariable("id") String id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        TesaurosTermino.findTesaurosTermino(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/tesaurosterminoes";
    }
    
    @ModelAttribute("tesaurosterminoes")
    public Collection<TesaurosTermino> TesaurosTerminoController.populateTesaurosTerminoes() {
        return TesaurosTermino.findAllTesaurosTerminoes();
    }
    
    String TesaurosTerminoController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
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
