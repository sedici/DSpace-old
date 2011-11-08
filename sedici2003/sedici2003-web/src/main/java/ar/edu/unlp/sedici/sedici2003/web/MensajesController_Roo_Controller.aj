// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.web;

import ar.edu.unlp.sedici.sedici2003.model.Mensajes;
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

privileged aspect MensajesController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String MensajesController.create(@Valid Mensajes mensajes, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("mensajes", mensajes);
            addDateTimeFormatPatterns(uiModel);
            return "mensajeses/create";
        }
        uiModel.asMap().clear();
        mensajes.persist();
        return "redirect:/mensajeses/" + encodeUrlPathSegment(mensajes.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String MensajesController.createForm(Model uiModel) {
        uiModel.addAttribute("mensajes", new Mensajes());
        addDateTimeFormatPatterns(uiModel);
        return "mensajeses/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String MensajesController.show(@PathVariable("id") Integer id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("mensajes", Mensajes.findMensajes(id));
        uiModel.addAttribute("itemId", id);
        return "mensajeses/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String MensajesController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("mensajeses", Mensajes.findMensajesEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Mensajes.countMensajeses() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("mensajeses", Mensajes.findAllMensajeses());
        }
        addDateTimeFormatPatterns(uiModel);
        return "mensajeses/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String MensajesController.update(@Valid Mensajes mensajes, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("mensajes", mensajes);
            addDateTimeFormatPatterns(uiModel);
            return "mensajeses/update";
        }
        uiModel.asMap().clear();
        mensajes.merge();
        return "redirect:/mensajeses/" + encodeUrlPathSegment(mensajes.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String MensajesController.updateForm(@PathVariable("id") Integer id, Model uiModel) {
        uiModel.addAttribute("mensajes", Mensajes.findMensajes(id));
        addDateTimeFormatPatterns(uiModel);
        return "mensajeses/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String MensajesController.delete(@PathVariable("id") Integer id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Mensajes.findMensajes(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/mensajeses";
    }
    
    @ModelAttribute("mensajeses")
    public Collection<Mensajes> MensajesController.populateMensajeses() {
        return Mensajes.findAllMensajeses();
    }
    
    void MensajesController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("mensajes_fechaactualizacionen_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("mensajes_fechaactualizaciones_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("mensajes_fechaactualizacionpt_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
    }
    
    String MensajesController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
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
