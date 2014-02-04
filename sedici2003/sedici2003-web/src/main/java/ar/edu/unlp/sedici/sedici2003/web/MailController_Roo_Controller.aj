// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.web;

import ar.edu.unlp.sedici.sedici2003.model.Mail;
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

privileged aspect MailController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String MailController.create(@Valid Mail mail, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("mail", mail);
            addDateTimeFormatPatterns(uiModel);
            return "mails/create";
        }
        uiModel.asMap().clear();
        mail.persist();
        return "redirect:/mails/" + encodeUrlPathSegment(mail.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String MailController.createForm(Model uiModel) {
        uiModel.addAttribute("mail", new Mail());
        addDateTimeFormatPatterns(uiModel);
        return "mails/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String MailController.show(@PathVariable("id") Integer id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("mail", Mail.findMail(id));
        uiModel.addAttribute("itemId", id);
        return "mails/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String MailController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("mails", Mail.findMailEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Mail.countMails() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("mails", Mail.findAllMails());
        }
        addDateTimeFormatPatterns(uiModel);
        return "mails/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String MailController.update(@Valid Mail mail, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("mail", mail);
            addDateTimeFormatPatterns(uiModel);
            return "mails/update";
        }
        uiModel.asMap().clear();
        mail.merge();
        return "redirect:/mails/" + encodeUrlPathSegment(mail.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String MailController.updateForm(@PathVariable("id") Integer id, Model uiModel) {
        uiModel.addAttribute("mail", Mail.findMail(id));
        addDateTimeFormatPatterns(uiModel);
        return "mails/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String MailController.delete(@PathVariable("id") Integer id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Mail.findMail(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/mails";
    }
    
    @ModelAttribute("mails")
    public Collection<Mail> MailController.populateMails() {
        return Mail.findAllMails();
    }
    
    void MailController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("mail_fechahora_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("mail_fechahoraalta_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
    }
    
    String MailController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
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