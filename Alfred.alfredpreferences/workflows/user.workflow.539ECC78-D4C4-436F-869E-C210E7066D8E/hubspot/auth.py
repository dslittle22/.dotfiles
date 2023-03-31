import subprocess, sys

import requests

from workflow import PasswordNotFound

import utils
from okta_auth import OktaAuth, get_okta_keychain_key

GITHUB_ACCESS_TOKEN_MSG = "Enter your GitHub Personal Access Token for Alfred.\n\nVisit HubSpot/alfred-hubspotdev-tools for instructions."
INSTALL_HSAUTHCTL = "nex run && brew update && brew upgrade hsenv"


class Auth(object):
    def __init__(self, wf):
        self.wf = wf

    def corp(self, clear=False):
        return self.user_pass("corp", "CORP (Okta)", None, clear)

    def prodlogin(self, clear=False):
        if clear:
            try:
                self.wf.delete_password("prodlogin")
            except PasswordNotFound:
                pass

        try:
            token = self.wf.get_password("prodlogin")
        except PasswordNotFound:
            token = self.call_hsauthctl()
            self.wf.save_password("prodlogin", token)

        return token

    def call_hsauthctl(self):
        try:
            p = subprocess.Popen(
                ["hsauthctl", "janus", "get-token"],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
            )
            result, _ = p.communicate()
        except:
            self.install_hsauthctl()

        if p.returncode == 1:
            self.install_hsauthctl()

        return result.split()[-1]

    def prodlogin_headers(self, clear=False):
        return {"Authorization": "Bearer %s" % self.prodlogin(clear=clear)}

    def github(self, clear=False):
        return self.user_pass(
            "github",
            "GitHub (Password or Access Token)",
            GITHUB_ACCESS_TOKEN_MSG,
            clear,
        )

    def okta(self, env, clear=False):
        if clear:
            try:
                key = get_okta_keychain_key(env)
                self.wf.delete_password(key)
            except PasswordNotFound:
                pass

        return OktaAuth(self.wf, env)

    def user_pass(self, type_key, type_name, message=None, clear=False):
        if clear:
            del self.wf.settings["user"]
            try:
                self.wf.delete_password(type_key)
            except PasswordNotFound:
                pass

        try:
            user = self.wf.settings["user"]
        except KeyError:
            user = None

        if not user:
            user = utils.ask_for_input(self.wf, "Username:", "Login")
            self.wf.settings["user"] = user

        try:
            password = self.wf.get_password(type_key)
        except PasswordNotFound:
            password = utils.ask_for_input(
                self.wf,
                message or "Password for %s:" % type_name,
                "%s Login" % type_name,
                password=True,
            )
            self.wf.save_password(type_key, password)

        return (user, password)

    def are_you_on_the_vpn(self):
        self.wf.add_item("Are you on the VPN?")
        self.wf.send_feedback()
        sys.exit(0)

    def install_hsauthctl(self):
        cmd = 'echo "' + INSTALL_HSAUTHCTL + '"|pbcopy'
        subprocess.call(cmd, shell=True)
        self.wf.add_item(
            "Error calling hsauthctl, paste command below",
            INSTALL_HSAUTHCTL,
        )
        self.wf.send_feedback()
        sys.exit(0)
